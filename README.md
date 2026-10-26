# ZBR Standards — site e documentação

Site oficial da biblioteca **[br_standards_with_zod](https://www.npmjs.com/package/br_standards_with_zod)**:
validação de documentos brasileiros (CPF, CNPJ, RG, CEP e telefone) com Zod.

- **Home** — apresentação, instalação e exemplos de uso
- **Playground** — validação em tempo real, 100% no navegador
- **Integrações** — exemplos prontos para React Hook Form, Vue 3, Fastify, Express e NestJS

## Stack

Vue 3 · Vite · TypeScript · vue-router · highlight.js · lucide-vue-next · Fontsource (Inter e JetBrains Mono).

## Desenvolvimento

```bash
npm install
npm run dev       # servidor local
npm run build     # type-check + build de produção
npm run preview   # serve o build
npm run typecheck # apenas o vue-tsc
```

## Estrutura

```
src/
  components/     nav, site-footer, CodeBlock
  pages/          home, playground, integracoes, not-found
  data/           exemplos de integração (conteúdo dos code blocks)
  router/         rotas, títulos por página e scroll behavior
  style.css       design tokens, base e tema do código
public/           favicon, og-image, robots.txt, sitemap.xml
scripts/          gerador do og-image (PowerShell + System.Drawing)
```

## Design

Todo o visual é controlado por tokens em `src/style.css` (`--bg`, `--surface`, `--accent`,
`--radius`, `--space-*`, tipografia, movimento). Páginas e componentes usam apenas essas variáveis —
para mudar a identidade do site, basta editar o bloco `:root`.

- Acento: azul `#38bdf8` · sucesso: verde `#34d399` (usado só em estados válidos)
- Fontes self-hosted: Inter Variable (texto) e JetBrains Mono (código)
- Tema de syntax highlighting em `style.css` (classes `.hljs-*`)

## Assets

O `public/og-image.png` é gerado por `scripts/og-image.ps1` (Windows/PowerShell) e usa a logo
recortada em `src/assets/imgs/logo-zbr.png`.

## Deploy

Publicado na Vercel. `vercel.json` concentra o rewrite da SPA, os headers de segurança e o cache
dos assets com hash.
