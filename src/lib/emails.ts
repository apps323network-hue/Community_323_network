import { supabase } from './supabase'

export async function sendEmail(to: string, subject: string, html: string, fromName?: string) {
  const { data: { session } } = await supabase.auth.getSession()

  const { data, error } = await supabase.functions.invoke('send-email', {
    body: { to, subject, html, fromName },
    headers: {
      Authorization: `Bearer ${session?.access_token}`
    }
  })

  if (error) {
    console.error('Error sending email:', error)
    return { success: false, error }
  }

  return { success: true, data }
}

export async function sendConnectionRequestEmail(toEmail: string, recipientName: string, requesterName: string) {
  const subject = `Nova solicitação de conexão - ${requesterName}`
  const logoUrl = 'https://pgdvbanwumqjmqeybqnw.supabase.co/storage/v1/object/public/avatars/logo/logo.png'

  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        .email-container {
          font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
          max-width: 600px;
          margin: 0 auto;
          background-color: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          overflow: hidden;
        }
        .header {
          background-color: #0c0f16;
          padding: 40px 30px;
          text-align: center;
        }
        .logo {
          width: 130px;
          height: auto;
        }
        .content {
          padding: 50px 40px;
          color: #1e293b;
          line-height: 1.6;
        }
        .greeting {
          font-size: 22px;
          font-weight: 600;
          margin-bottom: 24px;
          color: #0f172a;
          text-align: center;
        }
        .message {
          font-size: 16px;
          margin-bottom: 32px;
          text-align: center;
          color: #475569;
        }
        .requester-box {
          background-color: #f8fafc;
          border: 1px solid #f1f5f9;
          border-radius: 8px;
          padding: 30px;
          margin-bottom: 32px;
          text-align: center;
        }
        .button-container {
          text-align: center;
        }
        .button {
          display: inline-block;
          background-color: #f425f4;
          color: #ffffff !important;
          padding: 16px 48px;
          text-decoration: none;
          border-radius: 6px;
          font-weight: 600;
          font-size: 14px;
          text-transform: uppercase;
          letter-spacing: 1.5px;
        }
        .footer {
          background-color: #ffffff;
          padding: 40px 20px;
          text-align: center;
          font-size: 11px;
          color: #94a3b8;
          border-top: 1px solid #f1f5f9;
          text-transform: uppercase;
          letter-spacing: 1px;
        }
      </style>
    </head>
    <body style="background-color: #f8fafc; padding: 40px 0;">
      <div class="email-container">
        <div class="header">
          <img src="${logoUrl}" alt="323 Network" class="logo">
        </div>
        <div class="content">
          <h1 class="greeting">Olá, ${recipientName}</h1>
          <p class="message">
            Você recebeu uma nova solicitação para expandir sua rede profissional na 323 Network.
          </p>
          <div class="requester-box">
            <div style="font-size: 12px; color: #94a3b8; text-transform: uppercase; letter-spacing: 2px; font-weight: 700; margin-bottom: 12px;">Solicitação de Conexão</div>
            <div style="font-size: 20px; color: #0f172a; font-weight: 600;">${requesterName}</div>
          </div>
          <div class="button-container">
            <a href="${window.location.origin}/conexoes" class="button">Ver Perfil</a>
          </div>
        </div>
        <div class="footer">
          323 Network<br>
          Building bridges, creating opportunities.
        </div>
      </div>
    </body>
    </html>
  `
  return sendEmail(toEmail, subject, html)
}

// Função para enviar email de contato de parceiros (sem autenticação necessária)
export async function sendPartnerContactEmail(formData: {
  name: string
  company: string
  email: string
  phone?: string
  subject: string
  message: string
}) {
  const subject = `Nova solicitação de parceria - ${formData.company}`
  const logoUrl = 'https://pgdvbanwumqjmqeybqnw.supabase.co/storage/v1/object/public/avatars/logo/logo.png'
  
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        .email-container {
          font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
          max-width: 600px;
          margin: 0 auto;
          background-color: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          overflow: hidden;
        }
        .header {
          background-color: #0c0f16;
          padding: 40px 30px;
          text-align: center;
        }
        .logo {
          width: 130px;
          height: auto;
        }
        .content {
          padding: 50px 40px;
          color: #1e293b;
          line-height: 1.6;
        }
        .greeting {
          font-size: 22px;
          font-weight: 600;
          margin-bottom: 24px;
          color: #0f172a;
          text-align: center;
        }
        .info-box {
          background-color: #f8fafc;
          border: 1px solid #f1f5f9;
          border-radius: 8px;
          padding: 30px;
          margin-bottom: 32px;
        }
        .info-row {
          margin-bottom: 20px;
        }
        .info-row:last-child {
          margin-bottom: 0;
        }
        .info-label {
          font-size: 12px;
          color: #94a3b8;
          text-transform: uppercase;
          letter-spacing: 2px;
          font-weight: 700;
          margin-bottom: 8px;
        }
        .info-value {
          font-size: 16px;
          color: #0f172a;
          font-weight: 500;
        }
        .message-box {
          background-color: #f8fafc;
          border: 1px solid #f1f5f9;
          border-radius: 8px;
          padding: 30px;
          margin-top: 24px;
        }
        .message-label {
          font-size: 12px;
          color: #94a3b8;
          text-transform: uppercase;
          letter-spacing: 2px;
          font-weight: 700;
          margin-bottom: 12px;
        }
        .message-content {
          font-size: 15px;
          color: #1e293b;
          line-height: 1.7;
          white-space: pre-wrap;
        }
        .footer {
          background-color: #ffffff;
          padding: 40px 20px;
          text-align: center;
          font-size: 11px;
          color: #94a3b8;
          border-top: 1px solid #f1f5f9;
          text-transform: uppercase;
          letter-spacing: 1px;
        }
      </style>
    </head>
    <body style="background-color: #f8fafc; padding: 40px 0;">
      <div class="email-container">
        <div class="header">
          <img src="${logoUrl}" alt="323 Network" class="logo">
        </div>
        <div class="content">
          <h1 class="greeting">Nova Solicitação de Parceria</h1>
          
          <div class="info-box">
            <div class="info-row">
              <div class="info-label">Nome</div>
              <div class="info-value">${formData.name}</div>
            </div>
            <div class="info-row">
              <div class="info-label">Empresa</div>
              <div class="info-value">${formData.company}</div>
            </div>
            <div class="info-row">
              <div class="info-label">Email</div>
              <div class="info-value">${formData.email}</div>
            </div>
            ${formData.phone ? `
            <div class="info-row">
              <div class="info-label">Telefone</div>
              <div class="info-value">${formData.phone}</div>
            </div>
            ` : ''}
            <div class="info-row">
              <div class="info-label">Assunto</div>
              <div class="info-value">${formData.subject}</div>
            </div>
          </div>

          <div class="message-box">
            <div class="message-label">Mensagem</div>
            <div class="message-content">${formData.message}</div>
          </div>
        </div>
        <div class="footer">
          323 Network<br>
          Building bridges, creating opportunities.
        </div>
      </div>
    </body>
    </html>
  `
  
  // Chamar a Edge Function (a função send-email não requer autenticação)
  const { data, error } = await supabase.functions.invoke('send-email', {
    body: { 
      to: 'apps323network@gmail.com',
      subject,
      html,
      fromName: '323 Network - Parceiros'
    }
  })

  if (error) {
    console.error('Error sending partner contact email:', error)
    return { success: false, error }
  }

  return { success: true, data }
}