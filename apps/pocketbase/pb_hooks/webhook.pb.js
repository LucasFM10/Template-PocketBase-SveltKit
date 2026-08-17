// ============================================================
// PocketBase JS Hook — Rota Backend /api/webhook (Mercado Pago Webhook / Notifications)
// ============================================================

// Handlers GET para testes de conectividade / verificação de URL pelo Mercado Pago
routerAdd("GET", "/api/webhook", (c) => {
    return c.json(200, {
        status: "ok",
        message: "Endpoint de Webhook Mercado Pago ativo e operacional"
    });
});

// Handler POST principal para recebimento de notificações do Mercado Pago
routerAdd("POST", "/api/webhook", (c) => {
    try {
        // 1. Obter MERCADO_PAGO_ACCESS_TOKEN exclusivamente no backend
        let token = $os.getenv("MERCADO_PAGO_ACCESS_TOKEN") || (typeof process !== "undefined" && process.env ? process.env.MERCADO_PAGO_ACCESS_TOKEN : "");
        
        if (!token || token === "") {
            try {
                const envContent = $os.readFile("apps/pocketbase/.env") || $os.readFile(".env");
                if (envContent) {
                    const lines = envContent.split("\n");
                    for (let i = 0; i < lines.length; i++) {
                        const line = lines[i].trim();
                        if (line.startsWith("MERCADO_PAGO_ACCESS_TOKEN=")) {
                            token = line.split("=")[1].trim();
                            break;
                        }
                    }
                }
            } catch (e) {
                // ignorar erro de leitura
            }
        }

        // 2. Extrair dados da requisição enviados pelo Mercado Pago (Body, Query Params e Headers)
        let reqData = {};
        let queryParams = {};
        let headers = {};

        try {
            if (c.requestInfo) {
                const info = c.requestInfo();
                reqData = info ? (info.body || info.data || {}) : {};
                queryParams = info ? (info.query || {}) : {};
                headers = info ? (info.headers || {}) : {};
            } else if (typeof $apis !== "undefined" && $apis.requestInfo) {
                const info = $apis.requestInfo(c);
                reqData = info ? (info.body || info.data || {}) : {};
                queryParams = info ? (info.query || {}) : {};
                headers = info ? (info.headers || {}) : {};
            }
        } catch (e) {
            reqData = {};
        }

        // 3. Extrair tipo de ação, tipo de evento e ID da entidade
        const action = reqData.action || queryParams.topic || queryParams.type || "order.processed";
        const type = reqData.type || queryParams.topic || "order";
        let entityId = null;

        if (reqData.data && reqData.data.id) {
            entityId = String(reqData.data.id);
        } else if (reqData.id) {
            entityId = String(reqData.id);
        } else if (queryParams.id) {
            entityId = String(queryParams.id);
        } else if (reqData.resource) {
            const parts = String(reqData.resource).split('/');
            entityId = parts[parts.length - 1];
        }

        // 4. Validação opcional da Assinatura HMAC (X-Signature) se MERCADO_PAGO_WEBHOOK_SECRET estiver configurado
        const webhookSecret = $os.getenv("MERCADO_PAGO_WEBHOOK_SECRET") || "";
        const xSignature = headers["x-signature"] || headers["X-Signature"] || "";
        let isSignatureValid = true;

        if (webhookSecret && xSignature) {
            try {
                const parts = String(xSignature).split(",");
                let ts = "";
                let hashV1 = "";
                for (let i = 0; i < parts.length; i++) {
                    const kv = parts[i].split("=");
                    if (kv[0].trim() === "ts") ts = kv[1].trim();
                    if (kv[0].trim() === "v1") hashV1 = kv[1].trim();
                }

                if (ts && hashV1 && typeof $security !== "undefined" && $security.hs256) {
                    const manifest = "id:" + (entityId || "") + ";ts:" + ts + ";";
                    const expectedHash = $security.hs256(manifest, webhookSecret);
                    if (expectedHash !== hashV1) {
                        isSignatureValid = false;
                        console.log("⚠️ [Webhook] Assinatura X-Signature divergente do segredo cadastrado.");
                    }
                }
            } catch (e) {
                // tratamento gracioso de parsing
            }
        }

        // 5. Se o Access Token for placeholder ou não configurado, registrar simulação e responder 200 OK
        if (!token || token === "APP_USR_EXEMPLO") {
            console.log("ℹ️ [Webhook Simulação] Recebido evento:", {
                action: action,
                type: type,
                entity_id: entityId,
                modo: "exemplo_placeholder"
            });
            return c.json(200, {
                status: "ok",
                message: "Webhook de teste recebido (Credenciais em modo placeholder)"
            });
        }

        // 6. Consultar a Orders API (ou Payments API) do Mercado Pago para obter o estado real
        let confirmedStatus = "unknown";

        if (entityId) {
            const isOrder = type === "order" || action.indexOf("order") !== -1 || (reqData.resource && reqData.resource.indexOf("orders") !== -1);
            const isPayment = type === "payment" || action.indexOf("payment") !== -1 || (reqData.resource && reqData.resource.indexOf("payments") !== -1);

            let endpointUrl = "";
            if (isPayment && !isOrder) {
                endpointUrl = "https://api.mercadopago.com/v1/payments/" + entityId;
            } else {
                endpointUrl = "https://api.mercadopago.com/v1/orders/" + entityId;
            }

            try {
                const mpResponse = $http.send({
                    url: endpointUrl,
                    method: "GET",
                    headers: {
                        "Authorization": "Bearer " + token,
                        "Content-Type": "application/json"
                    }
                });

                if (mpResponse.statusCode === 200) {
                    const resData = mpResponse.json || {};
                    confirmedStatus = resData.status || "processed";
                } else if (mpResponse.statusCode === 404) {
                    // ID fictício enviado pela ferramenta de simulação do painel do Mercado Pago
                    confirmedStatus = "simulated_test_id";
                } else {
                    confirmedStatus = "api_error_http_" + mpResponse.statusCode;
                }
            } catch (errApi) {
                confirmedStatus = "fetch_exception";
            }
        }

        // 7. Log seguro (sem expor tokens ou credenciais)
        console.log("✅ [Webhook Mercado Pago Processado]:", {
            action: action,
            type: type,
            entity_id: entityId,
            status_confirmado: confirmedStatus,
            assinatura_valida: isSignatureValid
        });

        // 8. Responder rapidamente 200 OK para o Mercado Pago
        return c.json(200, {
            status: "ok",
            action: action,
            entity_id: entityId,
            confirmed_status: confirmedStatus
        });

    } catch (err) {
        console.log("❌ [Webhook Erro Interno]:", String(err));
        return c.json(200, {
            status: "ok",
            message: "Notificação recebida com tratamento de exceção"
        });
    }
});
