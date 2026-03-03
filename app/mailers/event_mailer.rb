class EventMailer < ApplicationMailer
  def send_event_email(member, title, body)
    @title = title
    @body = body
    mail(
      to: member.email,
      subject: title
    )
  end
end
