import PocketBase from 'pocketbase';
import { env } from '$env/dynamic/public';

const pbUrl = import.meta.env.PUBLIC_POCKETBASE_URL || env.PUBLIC_POCKETBASE_URL || 'http://127.0.0.1:8090';

if (typeof window !== 'undefined') {
	console.log('🔗 PocketBase URL em uso:', pbUrl);
}

export const pb = new PocketBase(pbUrl);
