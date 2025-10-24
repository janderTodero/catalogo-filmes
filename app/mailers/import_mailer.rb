class ImportMailer < ApplicationMailer
  default from: "no-reply@seusite.com"

  def started(import)
    @import = import
    mail(to: @import.user.email, subject: "Importação de filmes iniciada")
  end

  def completed(import, successes = [], failures = [])
    @import = import
    @successes = successes
    @failures = failures
    mail(to: @import.user.email, subject: "Importação de filmes concluída")
  end

  def failed(import, error_message)
    @import = import
    @error_message = error_message
    mail(to: @import.user.email, subject: "Falha na importação de filmes")
  end
end
