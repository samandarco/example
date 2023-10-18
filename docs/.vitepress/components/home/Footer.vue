<template>
	<footer>
		<div class="container">

		</div>
	</footer>
</template>

<script setup lang="ts">
import Divider from '../Divider.vue';
import SocialIcon from './SocialIcon.vue';
import Logo from './icons/Logo.vue';

const currentYear = new Date().getFullYear();
</script>

<style scoped>
footer {
	padding-bottom: 60px;
	background: var(--vp-docs-section-bg);
	padding: 24px 32px;
}

.container {
	max-width: 1000px;
	margin-inline: auto;
}

a {
	color: var(--vp-c-text-dark-2);
}

.content ul {
	display: flex;
	list-style: none;
	font-weight: 600;
	justify-content: space-between;
	gap: 12px;
	max-width: 500px;
}

.content .logo,
.content ul {
	margin-inline: auto;
	margin-block-end: 24px;
}

.content ul a:hover {
	color: white;
}

.content ul a:hover :deep(path) {
	fill: white;
}

@media screen and (min-width: 1000px) {
	.content {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 24px;
		align-items: center;
	}

	.content ul {
		margin: 0;
		width: 100%;
		gap: 24px;
	}

	.content .links {
		order: 1;
	}

	.content .logo {
		order: 2;
		margin: 0 auto;
	}

	.content .social {
		order: 3;
	}

	.divider {
		margin-top: 24px;
	}
}

small {
	text-align: center;
	color: var(--vp-c-text-dark-2);
	font-weight: 500;
	margin-block-start: 24px;
	display: block;
}
</style>
