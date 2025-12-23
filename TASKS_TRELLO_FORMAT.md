# 📋 FORMATO PARA TRELLO - 323 NETWORK
## Cards prontos para copiar/colar

---

## 🔴 LISTA: BACKLOG

### 🚀 ÉPICO 1: SETUP INICIAL E INFRAESTRUTURA

**Card 1.1**: Setup do Projeto
- Escolher stack (Next.js 14+ App Router recomendado)
- Configurar TypeScript
- Configurar ESLint + Prettier
- Setup de estrutura de pastas (app/, components/, lib/, types/)
- Configurar variáveis de ambiente

**Card 1.2**: Supabase Setup
- Criar projeto Supabase
- Configurar autenticação (Email/Password + OAuth opcional)
- Configurar Row Level Security (RLS) policies básicas
- Setup de migrations folder

**Card 1.3**: Design System / UI
- Escolher biblioteca UI (shadcn/ui recomendado)
- Configurar tema (cores, tipografia)
- Criar componentes base (Button, Card, Input, etc.)
- Setup de responsividade mobile-first
- Configurar navegação (menu lateral desktop / inferior mobile)

---

### 🔐 ÉPICO 2: AUTENTICAÇÃO E USUÁRIOS

**Card 2.1**: Autenticação
- Implementar login (email/password)
- Implementar registro/signup
- Implementar recuperação de senha
- Implementar logout
- Middleware de proteção de rotas

**Card 2.2**: Schema de Usuários (Supabase)
- Criar tabela `profiles` (extends auth.users)
- Campos: nome, area_atuacao, cidade, pais, objetivo, whatsapp, linkedin, plano, badge
- Criar RLS policies para profiles
- Criar função de criação automática de profile no signup

**Card 2.3**: 🚨 URGENTE - Correções de Banco
- Corrigir bug de usuário duplicado (Igor Gomes Evaristo)
- Criar script de validação para evitar duplicatas futuras
- Implementar constraint único em email/username

**Card 2.4**: Planos e Badges
- Criar enum/tabela de planos (Free, Member, Premium)
- Implementar sistema de badges
- Middleware de verificação de plano

---

### 🏠 ÉPICO 3: HOME / DASHBOARD

**Card 3.1**: Layout da Home
- Criar componente de boas-vindas personalizado
- Implementar seção "Objetivo atual" (dinâmico)
- Criar CTA rotativo semanal (sistema de rotação)
- Implementar seção "Benefícios ativos"
- Criar seção "Destaques" (próximo evento, post fixado, serviço em destaque)

**Card 3.2**: Lógica de Dados da Home
- Criar query para buscar objetivo atual do usuário
- Criar sistema de rotação de CTAs (semanal)
- Query para benefícios ativos do usuário
- Query para destaques (eventos, posts, serviços)

---

### 💬 ÉPICO 4: COMUNIDADE / FEED (CORE) ⭐

**Card 4.1**: Schema de Posts
- Criar tabela `posts` (user_id, tipo, conteudo, fixado, timestamps)
- Criar tabela `post_likes` (relação many-to-many)
- Criar tabela `post_comments`
- Configurar RLS para posts

**Card 4.2**: UI do Feed
- Criar componente de card de post
- Implementar timeline/feed infinito (infinite scroll)
- Criar componente de criação de post (modal ou inline)
- Implementar seleção de tipo de post (ícones: 🤝 💼 🔎 📣)
- Implementar sistema de likes (otimistic updates)
- Implementar sistema de comentários (thread)
- Implementar posts fixados (destaque no topo)

**Card 4.3**: Filtros e Busca do Feed
- Criar filtros por tipo de post
- Implementar busca de posts (full-text search)
- Implementar ordenação (recentes, mais curtidos)

**Card 4.4**: Interações do Feed
- Implementar notificações de likes/comentários
- Criar sistema de menções (@username)
- Implementar compartilhamento de posts

---

### 👥 ÉPICO 5: MEMBROS / DIRETÓRIO

**Card 5.1**: Schema e Queries de Membros
- Criar view/query para listagem de membros
- Implementar busca de membros (nome, área, cidade)
- Criar filtros (área de atuação, cidade/estado, objetivo, plano)

**Card 5.2**: UI do Diretório
- Criar componente de card de membro (nome, área, cidade/pais, objetivo, badge)
- Implementar grid/listagem de membros
- Criar botões de ação (WhatsApp, LinkedIn) com links externos
- Implementar paginação ou infinite scroll

**Card 5.3**: Perfil Público
- Criar página de perfil público (/membros/[id])
- Exibir informações públicas do membro
- Exibir posts do membro (opcional)

---

### 📅 ÉPICO 6: EVENTOS

**Card 6.1**: Schema de Eventos
- Criar tabela `events` (titulo, descricao, data_hora, tipo, local, link_gravacao)
- Criar tabela `event_confirmations` (relação many-to-many)
- Configurar RLS para eventos

**Card 6.2**: UI de Eventos
- Criar página de listagem de eventos
- Criar card de evento
- Implementar botão "Confirmar presença"
- Criar página de detalhes do evento
- Implementar exibição de gravação (pós-evento)
- Criar CTA para serviço relacionado (pós-evento)

**Card 6.3**: Calendário de Eventos
- Implementar visualização de calendário (biblioteca: react-big-calendar ou similar)
- Filtrar eventos por tipo (presencial/webinar)
- Implementar evento fixo semanal (MVP: 1 evento)

**Card 6.4**: Admin de Eventos
- Criar interface para empresas parceiras cadastrarem eventos
- Implementar aprovação de eventos (se necessário)

---

### 🛒 ÉPICO 7: SERVIÇOS / MARKETPLACE

**Card 7.1**: Schema de Serviços
- Criar tabela `services` (nome, descricao, parceiro_id, categoria, beneficio_membro)
- Criar tabela `service_requests` (solicitações de atendimento)
- Criar tabela `partners` (empresas parceiras)
- Configurar RLS

**Card 7.2**: UI do Marketplace
- Criar página de listagem de serviços
- Criar card de serviço (nome, descricao, benefício, botão "Solicitar atendimento")
- Implementar filtros por categoria
- Implementar serviço em destaque (home)
- Criar modal/formulário de solicitação de atendimento

**Card 7.3**: Gestão de Solicitações
- Criar página de solicitações do usuário
- Implementar status de solicitação (pendente, em andamento, concluído)
- Notificar parceiro sobre nova solicitação

---

### 🎁 ÉPICO 8: BENEFÍCIOS

**Card 8.1**: Schema de Benefícios
- Criar tabela `benefits` (nome, descricao, tipo, plano_requerido, valido_ate)
- Criar tabela `user_benefits` (benefícios utilizados)
- Configurar RLS

**Card 8.2**: UI de Benefícios
- Criar página de listagem de benefícios
- Implementar seção "Benefício do mês"
- Implementar seção "Benefícios fixos"
- Implementar bloqueio de benefícios por plano (🔒)
- Criar CTA de upsell (Desbloquear no plano Member/Premium)
- Implementar ativação/utilização de benefício

**Card 8.3**: Lógica de Benefícios
- Criar sistema de rotação de "Benefício do mês"
- Implementar validação de elegibilidade por plano
- Criar histórico de benefícios utilizados

---

### 👤 ÉPICO 9: PERFIL DO USUÁRIO

**Card 9.1**: Edição de Perfil
- Criar página de edição de perfil (/perfil/editar)
- Formulário com campos: nome, área, cidade, país, objetivo, WhatsApp, LinkedIn
- Implementar upload de foto de perfil (Supabase Storage)
- Exibir plano atual e badge
- Implementar atualização de perfil

**Card 9.2**: Visualização de Perfil
- Criar página de perfil próprio (/perfil)
- Exibir informações do perfil
- Criar seção de histórico:
  - Eventos confirmados
  - Serviços solicitados
  - Benefícios utilizados

**Card 9.3**: Gestão de Plano
- Criar interface de upgrade de plano
- Integrar com sistema de pagamento (Stripe/PagSeguro)
- Implementar downgrade/cancelamento

---

### 🎮 ÉPICO 10: GAMIFICAÇÃO (RETENÇÃO)

**Card 10.1**: Sistema de Desafios
- Criar tabela `challenges` (nome, descricao, tipo, pontos, prazo)
- Criar tabela `user_challenges` (progresso)
- Implementar sistema de pontos

**Card 10.2**: UI de Gamificação
- Criar página de desafios
- Exibir progresso do usuário
- Implementar badges de conquistas
- Criar leaderboard (opcional)

---

### 🐛 ÉPICO 11: CORREÇÕES URGENTES

**Card 11.1**: 🚨 URGENTE - Correções de Banco
- Identificar e deletar usuário duplicado (Igor Gomes Evaristo)
- Criar script de validação para evitar duplicatas futuras
- Implementar constraint único em email/username

**Card 11.2**: 🚨 URGENTE - Correções de Copy (Landing Page)
- Corrigir seção de Pricing
  - Alterar texto para deixar claro que US$ 999 é ENTRADA (Down Payment)
  - Novo texto: "Entrada de 50% (US$ 999) para iniciar a mentoria. O restante na 2ª fase."
  - Alterar CTA para "Garantir minha vaga com a entrada"
- Corrigir títulos da equipe
  - Generalizar para "Especialista em Vistos" (remover especificidade F1/EB2)

---

### 🔧 ÉPICO 12: INFRAESTRUTURA E DEVOPS

**Card 12.1**: Performance
- Implementar cache de queries (React Query/SWR)
- Otimizar imagens (Next.js Image)
- Implementar lazy loading de componentes
- Setup de CDN (se necessário)

**Card 12.2**: Monitoramento
- Configurar error tracking (Sentry)
- Setup de analytics (Google Analytics / Plausible)
- Implementar logging de ações importantes

**Card 12.3**: Deploy
- Configurar Vercel/Netlify para deploy
- Setup de CI/CD (GitHub Actions)
- Configurar domínio customizado
- Setup de staging environment

---

### 📱 ÉPICO 13: MOBILE-FIRST E UX

**Card 13.1**: Responsividade
- Garantir que todas as telas sejam mobile-first
- Testar em diferentes tamanhos de tela
- Implementar menu inferior no mobile
- Implementar menu lateral no desktop

**Card 13.2**: Acessibilidade
- Adicionar aria-labels
- Garantir contraste adequado
- Testar navegação por teclado
- Implementar focus states

**Card 13.3**: Performance Mobile
- Otimizar bundle size
- Implementar service worker (PWA opcional)
- Testar performance em 3G/4G

---

### 🧪 ÉPICO 14: TESTES

**Card 14.1**: Testes Unitários
- Setup de Jest/Vitest
- Testar funções utilitárias
- Testar componentes críticos

**Card 14.2**: Testes E2E
- Setup de Playwright/Cypress
- Testar fluxo de autenticação
- Testar criação de post
- Testar confirmação de evento

---

### 📚 ÉPICO 15: DOCUMENTAÇÃO

**Card 15.1**: Documentação Técnica
- Criar README.md com setup
- Documentar estrutura de pastas
- Documentar schema do banco
- Documentar APIs/endpoints

**Card 15.2**: Documentação de Usuário
- Criar guia de uso básico
- Documentar funcionalidades principais
- Criar FAQ

---

## 🟡 LISTA: EM ANDAMENTO
*(Cards movidos do Backlog conforme desenvolvimento)*

---

## 🟢 LISTA: EM REVISÃO
*(Cards prontos aguardando code review)*

---

## ✅ LISTA: CONCLUÍDO
*(Cards finalizados e testados)*

---

## 📌 CHECKLIST POR CARD (Template)

Ao criar um card, adicionar checklist:

- [ ] Código funciona
- [ ] Mobile responsivo
- [ ] RLS configurado (se aplicável)
- [ ] TypeScript sem erros
- [ ] Acessibilidade básica
- [ ] Testado manualmente
- [ ] Code review aprovado

---

## 🏷️ LABELS SUGERIDAS

- `🚨 URGENTE` - Prioridade máxima
- `⭐ CORE` - Funcionalidade principal
- `🐛 BUG` - Correção de bug
- `📱 MOBILE` - Relacionado a mobile
- `🔒 SECURITY` - Segurança/RLS
- `🎨 UI/UX` - Interface/Experiência
- `⚡ PERFORMANCE` - Otimização
- `🧪 TEST` - Testes
- `📚 DOCS` - Documentação

---

## 👥 ASSIGNMENT SUGERIDO

- **Frontend**: Tasks de UI, componentes, páginas
- **Backend**: Tasks de schema, RLS, queries, APIs
- **Fullstack**: Tasks que envolvem ambos
- **DevOps**: Tasks de deploy, CI/CD, monitoramento

---

**Formato pronto para copiar/colar no Trello!**

