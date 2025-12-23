# 🎨 DESIGN SYSTEM - 323 NETWORK
## Referência Principal: Skool.com

---

## 🎯 FILOSOFIA DE DESIGN

### Inspiração Principal: Skool.com
O Skool é nossa **referência principal** para comunidade e networking. Focamos em:
- ✅ Interface limpa e minimalista
- ✅ Simplicidade e funcionalidade
- ✅ Experiência sem distrações
- ✅ Gamificação sutil e eficaz
- ✅ Estrutura intuitiva de duas colunas

**Referência**: [Skool.com](https://www.skool.com/)

---

## 📐 ESTRUTURA DE LAYOUT (Baseado no Skool)

### Layout Desktop: Duas Colunas

```
┌─────────────────────────────────────────┐
│  HEADER (Logo, Notificações, Perfil)    │
├──────────┬──────────────────────────────┤
│          │                              │
│ SIDEBAR  │   CONTEÚDO PRINCIPAL         │
│          │   (Feed/Posts)               │
│ • Home   │                              │
│ • Comun. │   ┌──────────────────────┐  │
│ • Membros│   │  POST 1              │  │
│ • Eventos│   │  ┌────────────────┐  │  │
│ • Serviços│   │  │ Conteúdo...   │  │  │
│ • Benef. │   │  └────────────────┘  │  │
│ • Perfil │   │  [Like] [Comment]    │  │
│          │   └──────────────────────┘  │
│          │                              │
│          │   ┌──────────────────────┐  │
│          │   │  POST 2              │  │
│          │   └──────────────────────┘  │
│          │                              │
└──────────┴──────────────────────────────┘
```

### Layout Mobile: Menu Inferior

```
┌─────────────────────────┐
│  HEADER (Logo, Perfil)  │
├─────────────────────────┤
│                         │
│   CONTEÚDO PRINCIPAL    │
│   (Feed/Posts)          │
│                         │
│   ┌─────────────────┐   │
│   │  POST 1         │   │
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │  POST 2         │   │
│   └─────────────────┘   │
│                         │
├─────────────────────────┤
│ [Home] [Comun] [Memb]   │
│ [Event] [Serv] [Perfil] │
└─────────────────────────┘
```

---

## 🎨 COMPONENTES PRINCIPAIS (Inspirados no Skool)

### 1. SIDEBAR (Desktop)

**Características**:
- Largura fixa: 240-280px
- Fundo: Branco ou cinza muito claro (#FAFAFA)
- Menu vertical com ícones + texto
- Item ativo destacado (cor primária)
- Posição fixa (sticky)

**Itens do Menu**:
```
🏠 Home
💬 Comunidade
👥 Membros
📅 Eventos
🛒 Serviços
🎁 Benefícios
👤 Perfil
```

**Estados**:
- **Normal**: Texto cinza (#6B7280), ícone cinza
- **Hover**: Fundo cinza claro (#F3F4F6)
- **Ativo**: Texto cor primária (#2563EB), fundo azul claro (#EFF6FF)

---

### 2. FEED DE POSTS (Core do Skool)

**Estrutura do Card de Post**:

```
┌─────────────────────────────────────┐
│ 👤 Nome do Usuário                  │
│    @username • há 2h                 │
├─────────────────────────────────────┤
│ 🤝 Networking / Parceria            │
├─────────────────────────────────────┤
│                                     │
│  Conteúdo do post aqui...          │
│  Pode ter múltiplas linhas         │
│                                     │
├─────────────────────────────────────┤
│ 💬 12  ❤️ 45  🔄 3  📤 Compartilhar │
└─────────────────────────────────────┘
```

**Características**:
- Card branco com sombra sutil (0 1px 3px rgba(0,0,0,0.1))
- Espaçamento entre posts: 16-20px
- Padding interno: 16-20px
- Bordas arredondadas: 8-12px
- Tipografia: Inter ou similar, 15-16px
- Tipo de post sempre visível (ícone + texto)

**Tipos de Post (com ícones)**:
- 🤝 **Networking / Parceria** - Azul (#2563EB)
- 💼 **Ofereço Serviço** - Verde (#10B981)
- 🔎 **Procuro Ajuda** - Laranja (#F59E0B)
- 📣 **Oportunidade** - Roxo (#8B5CF6)

---

### 3. CARD DE MEMBRO (Diretório)

**Estrutura**:

```
┌─────────────────────┐
│   [Foto Perfil]     │
│      Circular       │
├─────────────────────┤
│ Nome Completo       │
│ Área de Atuação     │
│ 📍 Cidade, País     │
│ 🎯 Objetivo         │
│                     │
│ [Badge: Member]     │
│                     │
│ [WhatsApp] [LinkedIn]
└─────────────────────┘
```

**Características**:
- Grid responsivo: 3-4 colunas desktop, 2 mobile
- Foto: 80-100px, circular
- Badge de plano sempre visível
- Botões de ação destacados
- Hover: leve elevação (shadow)

---

### 4. CARD DE EVENTO

**Estrutura**:

```
┌─────────────────────────────┐
│ 📅 Quinta-feira • 20h (EST) │
├─────────────────────────────┤
│ Encontro 323                │
│ Networking & Oportunidades  │
├─────────────────────────────┤
│ 📍 Online (Zoom)            │
│ 👥 45 confirmados            │
│                             │
│ [✅ Confirmar Presença]     │
└─────────────────────────────┘
```

**Características**:
- Data/hora em destaque
- Status visual (próximo, passado, ao vivo)
- Contador de confirmados
- CTA claro e destacado

---

### 5. GAMIFICAÇÃO (Sistema de Pontos - Estilo Skool)

**Elementos**:
- **Pontos**: Exibidos no perfil
- **Ranking**: Leaderboard opcional
- **Badges**: Conquistas visuais
- **Desafios**: Cards de desafios ativos

**Visual**:
- Números grandes e destacados
- Cores vibrantes para conquistas
- Progresso visual (barras, círculos)

---

## 🎨 PALETA DE CORES

### Cores Primárias (Baseadas no Skool - Limpo e Profissional)

```css
/* Primárias */
--primary: #2563EB;        /* Azul - Ações principais */
--primary-hover: #1D4ED8;  /* Azul escuro */
--primary-light: #EFF6FF;  /* Azul claro (fundos) */

/* Secundárias */
--success: #10B981;        /* Verde - Sucesso */
--warning: #F59E0B;       /* Laranja - Avisos */
--info: #8B5CF6;          /* Roxo - Informações */

/* Neutros (Skool usa muito branco/cinza claro) */
--gray-50: #FAFAFA;       /* Fundos principais */
--gray-100: #F3F4F6;      /* Fundos secundários */
--gray-200: #E5E7EB;      /* Bordas */
--gray-500: #6B7280;      /* Textos secundários */
--gray-900: #111827;      /* Textos principais */

/* Backgrounds */
--bg-primary: #FFFFFF;     /* Cards, fundo principal */
--bg-secondary: #FAFAFA;   /* Fundo da página */
```

### Aplicação de Cores

**Skool usa muito branco e cinza claro**:
- Fundo da página: #FAFAFA ou branco
- Cards: Branco (#FFFFFF)
- Texto principal: Cinza escuro (#111827)
- Texto secundário: Cinza médio (#6B7280)
- Ações: Azul (#2563EB)

---

## 📝 TIPOGRAFIA

### Fontes (Inspiradas no Skool)

**Principal**: Inter ou System Font Stack
```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
```

**Hierarquia**:
- **H1**: 32px, bold (Títulos principais)
- **H2**: 24px, semibold (Seções)
- **H3**: 20px, semibold (Subtítulos)
- **Body**: 16px, regular (Texto principal)
- **Small**: 14px, regular (Textos secundários)
- **Caption**: 12px, regular (Metadados)

**Pesos**:
- Regular: 400
- Medium: 500
- Semibold: 600
- Bold: 700

---

## 🎯 ESPAÇAMENTO (Sistema 8px)

Baseado no Skool (espaçamento generoso):

```css
--space-1: 4px;
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;    /* Padrão mais usado */
--space-5: 20px;
--space-6: 24px;
--space-8: 32px;
--space-10: 40px;
--space-12: 48px;
```

**Aplicação**:
- Padding de cards: 16-20px
- Espaçamento entre posts: 16-20px
- Margem lateral: 24-32px
- Espaçamento interno de componentes: 12-16px

---

## 🔘 BOTÕES (Estilo Skool - Simples e Claro)

### Botão Primário
```css
background: #2563EB;
color: white;
padding: 12px 24px;
border-radius: 8px;
font-weight: 500;
```

### Botão Secundário
```css
background: white;
color: #2563EB;
border: 1px solid #E5E7EB;
padding: 12px 24px;
border-radius: 8px;
```

### Botão de Ação (Like, Comment)
```css
background: transparent;
color: #6B7280;
padding: 8px 12px;
border-radius: 6px;
/* Hover muda cor */
```

**Estados**:
- **Normal**: Cor padrão
- **Hover**: Fundo cinza claro (#F3F4F6)
- **Active**: Cor primária
- **Disabled**: Opacidade 50%

---

## 📱 RESPONSIVIDADE (Mobile-First)

### Breakpoints
```css
/* Mobile First */
mobile: 0-640px      /* Menu inferior */
tablet: 641-1024px   /* Sidebar colapsável */
desktop: 1025px+     /* Sidebar fixa */
```

### Adaptações Mobile (Baseado no Skool)
- **Menu**: Inferior fixo (não sidebar)
- **Posts**: Largura total, padding reduzido
- **Cards**: Stack vertical
- **Botões**: Touch targets grandes (44x44px mínimo)
- **Tipografia**: Tamanhos ligeiramente menores

---

## 🎮 GAMIFICAÇÃO (Estilo Skool)

### Elementos Visuais

**Pontos**:
```
┌─────────────┐
│  1,234      │
│  Pontos     │
└─────────────┘
```
- Número grande e destacado
- Cor primária ou verde
- Fonte bold

**Badges/Conquistas**:
- Ícones circulares
- Cores vibrantes
- Tooltip com descrição

**Ranking**:
- Lista simples
- Posição destacada
- Progresso visual

---

## 🖼️ ÍCONES E IMAGENS

### Ícones
- **Biblioteca**: Lucide Icons ou Heroicons
- **Tamanho padrão**: 20-24px
- **Cor**: Cinza (#6B7280) ou cor do contexto
- **Estilo**: Outline (mais limpo, como Skool)

### Fotos de Perfil
- **Formato**: Circular
- **Tamanho**: 40px (pequeno), 80px (médio), 120px (grande)
- **Fallback**: Iniciais ou ícone genérico
- **Border**: 2px branco (quando sobreposto)

### Imagens de Posts
- **Aspect ratio**: 16:9 ou original
- **Border radius**: 8px
- **Lazy loading**: Sempre habilitado

---

## ✨ ANIMAÇÕES E TRANSIÇÕES (Sutis como Skool)

### Transições Padrão
```css
/* Hover em cards */
transition: all 0.2s ease;

/* Botões */
transition: background-color 0.15s ease;

/* Modais */
transition: opacity 0.2s ease, transform 0.2s ease;
```

### Animações
- **Loading**: Skeleton screens (não spinners)
- **Posts novos**: Fade in suave
- **Likes**: Pequeno bounce (opcional)
- **Scroll**: Suave, sem animações pesadas

**Princípio**: Menos é mais. Skool é minimalista.

---

## 🎯 COMPONENTES ESPECÍFICOS DO SKOOL

### 1. Feed de Comunidade
- **Scroll infinito**: Suave, sem loading pesado
- **Novos posts**: Aparecem no topo
- **Filtros**: Barra horizontal acima do feed
- **Criação de post**: Botão fixo ou no topo

### 2. Sistema de Notificações
- **Badge**: Número vermelho no ícone
- **Dropdown**: Lista simples, sem complexidade
- **Estados**: Lido/não lido visual

### 3. Perfil
- **Header**: Foto grande, informações principais
- **Tabs**: Comunidade, Eventos, Serviços
- **Estatísticas**: Números destacados

### 4. Calendário
- **Visualização**: Mês (padrão)
- **Eventos**: Dots coloridos nos dias
- **Detalhes**: Modal ou sidebar

---

## 📋 CHECKLIST DE DESIGN (Baseado no Skool)

### Princípios a Seguir:
- [ ] Interface limpa e minimalista
- [ ] Sem distrações visuais
- [ ] Espaçamento generoso
- [ ] Tipografia legível
- [ ] Cores sutis (muito branco/cinza)
- [ ] Ações claras e visíveis
- [ ] Mobile-first
- [ ] Performance > Animações

### Elementos Obrigatórios:
- [ ] Sidebar fixa (desktop)
- [ ] Menu inferior (mobile)
- [ ] Feed centralizado
- [ ] Cards com sombra sutil
- [ ] Tipos de post visíveis (ícones)
- [ ] Gamificação sutil
- [ ] Sistema de pontos

---

## 🔗 REFERÊNCIAS VISUAIS

### Inspiração Principal:
- **Skool.com**: [https://www.skool.com/](https://www.skool.com/)
  - Interface limpa
  - Feed centralizado
  - Gamificação integrada
  - Simplicidade funcional

### Inspirações Complementares:
- **Circle.so**: Estrutura de comunidade
- **Twitter**: Feed e interações
- **Linear**: Minimalismo e tipografia

---

## 🚀 PRÓXIMOS PASSOS

1. **Criar mockups** baseados neste design system
2. **Implementar componentes** no código
3. **Testar responsividade** mobile-first
4. **Validar com usuários** a experiência
5. **Iterar** baseado em feedback

---

**Design System criado em**: 2024  
**Versão**: 1.0  
**Referência Principal**: Skool.com  
**Status**: Pronto para implementação

