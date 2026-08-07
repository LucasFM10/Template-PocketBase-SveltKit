<script lang="ts">
	import { onMount } from 'svelte';
	import { pb } from '$lib/pocketbase';

	interface Batata {
		id: string;
		name: string;
		tipo: string;
	}

	let batatas = $state<Batata[]>([]);
	let loading = $state(true);
	let errorMsg = $state('');

	// Formulário para Nova Batata
	let newName = $state('');
	let newTipo = $state('Frita');

	// Estado para Edição
	let editingId = $state<string | null>(null);
	let editName = $state('');
	let editTipo = $state('');

	async function fetchBatatas() {
		try {
			loading = true;
			errorMsg = '';
			// Chamada simples sem parâmetros complexos de ordenação
			const records = await pb.collection('batatas').getFullList<Batata>();
			batatas = records;
		} catch (err: any) {
			console.error(err);
			errorMsg = 'Erro ao conectar ao PocketBase. Verifique se o container está rodando na porta 8090.';
		} finally {
			loading = false;
		}
	}

	async function addBatata(e: Event) {
		e.preventDefault();
		if (!newName.trim()) return;

		try {
			await pb.collection('batatas').create({
				name: newName,
				tipo: newTipo
			});

			newName = '';
			newTipo = 'Frita';
			await fetchBatatas();
		} catch (err: any) {
			alert('Erro ao adicionar batata: ' + err.message);
		}
	}

	function startEdit(b: Batata) {
		editingId = b.id;
		editName = b.name;
		editTipo = b.tipo || 'Frita';
	}

	function cancelEdit() {
		editingId = null;
		editName = '';
		editTipo = '';
	}

	async function saveEdit(id: string) {
		if (!editName.trim()) return;
		try {
			await pb.collection('batatas').update(id, {
				name: editName,
				tipo: editTipo
			});
			cancelEdit();
			await fetchBatatas();
		} catch (err: any) {
			alert('Erro ao atualizar batata: ' + err.message);
		}
	}

	async function deleteBatata(id: string) {
		if (!confirm('Deseja excluir esta batata? 🥔')) return;
		try {
			await pb.collection('batatas').delete(id);
			await fetchBatatas();
		} catch (err: any) {
			alert('Erro ao deletar: ' + err.message);
		}
	}

	onMount(() => {
		fetchBatatas();
	});
</script>

<svelte:head>
	<title>Gerenciador de Batatas 🥔 — Monorepo Template</title>
</svelte:head>

<div class="card">
	<h1>🥔 Gerenciador de Batatas</h1>
	<p class="subtitle">Exemplo CRUD simples conectando SvelteKit + PocketBase.</p>

	<!-- Formulário de Adicionar -->
	<form onsubmit={addBatata} class="form">
		<h2>Adicionar Nova Batata</h2>
		<div class="row">
			<input type="text" placeholder="Nome da Batata (ex: Batata Frita Crocante)" bind:value={newName} required />
			<select bind:value={newTipo}>
				<option value="Frita">Frita 🍟</option>
				<option value="Doce">Doce 🍠</option>
				<option value="Baroa">Baroa / Mandioquinha</option>
				<option value="Assada">Assada 🥔</option>
				<option value="Purê">Purê</option>
			</select>
			<button type="submit" class="btn-primary">+ Adicionar</button>
		</div>
	</form>

	<hr />

	<!-- Lista de Batatas -->
	<div class="header-list">
		<h2>Suas Batatas ({batatas.length})</h2>
		<button class="btn-refresh" onclick={fetchBatatas}>🔄 Atualizar</button>
	</div>

	{#if loading}
		<p class="info">Carregando batatas do PocketBase...</p>
	{:else if errorMsg}
		<div class="alert">
			⚠️ {errorMsg}
		</div>
	{:else if batatas.length === 0}
		<p class="empty">Nenhuma batata cadastrada ainda. Adicione a primeira batata acima!</p>
	{:else}
		<ul class="potato-list">
			{#each batatas as b (b.id)}
				<li class="potato-item">
					{#if editingId === b.id}
						<!-- Modo Edição -->
						<div class="edit-row">
							<input type="text" bind:value={editName} required />
							<select bind:value={editTipo}>
								<option value="Frita">Frita 🍟</option>
								<option value="Doce">Doce 🍠</option>
								<option value="Baroa">Baroa</option>
								<option value="Assada">Assada 🥔</option>
								<option value="Purê">Purê</option>
							</select>
							<button class="btn-save" onclick={() => saveEdit(b.id)}>Salvar</button>
							<button class="btn-cancel" onclick={cancelEdit}>Cancelar</button>
						</div>
					{:else}
						<!-- Modo Visualização -->
						<div class="info-row">
							<span class="name">🥔 <strong>{b.name}</strong></span>
							<span class="badge">{b.tipo || 'Frita'}</span>
						</div>
						<div class="actions">
							<button class="btn-edit" onclick={() => startEdit(b)}>✏️ Editar</button>
							<button class="btn-danger" onclick={() => deleteBatata(b.id)}>🗑️ Excluir</button>
						</div>
					{/if}
				</li>
			{/each}
		</ul>
	{/if}
</div>

<style>
	.card {
		background: white;
		padding: 2rem;
		border-radius: 12px;
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
	}
	h1 {
		margin-top: 0;
		font-size: 1.6rem;
		color: #1e293b;
	}
	.subtitle {
		color: #64748b;
		margin-bottom: 1.5rem;
	}
	form {
		background: #f8fafc;
		padding: 1.25rem;
		border-radius: 8px;
		border: 1px solid #e2e8f0;
	}
	form h2 {
		font-size: 1rem;
		margin-top: 0;
		margin-bottom: 0.75rem;
		color: #334155;
	}
	.row {
		display: flex;
		gap: 0.75rem;
		flex-wrap: wrap;
	}
	input, select {
		padding: 0.6rem 0.8rem;
		border: 1px solid #cbd5e1;
		border-radius: 6px;
		font-size: 0.9rem;
		flex: 1;
		min-width: 150px;
	}
	button {
		border: none;
		padding: 0.6rem 1rem;
		border-radius: 6px;
		cursor: pointer;
		font-weight: 600;
		font-size: 0.9rem;
	}
	.btn-primary {
		background: #ea580c;
		color: white;
	}
	.btn-primary:hover {
		background: #c2410c;
	}
	.btn-refresh {
		background: #e2e8f0;
		color: #334155;
		font-size: 0.8rem;
	}
	.btn-refresh:hover {
		background: #cbd5e1;
	}
	.btn-edit {
		background: #e0f2fe;
		color: #0369a1;
	}
	.btn-edit:hover {
		background: #bae6fd;
	}
	.btn-save {
		background: #16a34a;
		color: white;
	}
	.btn-cancel {
		background: #94a3b8;
		color: white;
	}
	.btn-danger {
		background: #fee2e2;
		color: #991b1b;
	}
	.btn-danger:hover {
		background: #fecaca;
	}
	hr {
		border: none;
		border-top: 1px solid #e2e8f0;
		margin: 1.5rem 0;
	}
	.header-list {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1rem;
	}
	.potato-list {
		list-style: none;
		padding: 0;
		margin: 0;
	}
	.potato-item {
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 0.8rem 1rem;
		border: 1px solid #e2e8f0;
		border-radius: 8px;
		margin-bottom: 0.5rem;
		background: #ffffff;
	}
	.info-row {
		display: flex;
		align-items: center;
		gap: 0.75rem;
	}
	.edit-row {
		display: flex;
		gap: 0.5rem;
		width: 100%;
	}
	.actions {
		display: flex;
		gap: 0.5rem;
	}
	.badge {
		background: #ffe4e6;
		color: #9f1239;
		padding: 0.2rem 0.6rem;
		border-radius: 9999px;
		font-size: 0.75rem;
		font-weight: 600;
	}
	.alert {
		background: #fef2f2;
		color: #991b1b;
		padding: 1rem;
		border-radius: 6px;
		border: 1px solid #fecaca;
	}
	.empty, .info {
		color: #64748b;
		font-style: italic;
	}
</style>
