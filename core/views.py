from django.core.mail import EmailMessage
from django.shortcuts import render, redirect
from django.conf import settings
from django.views.decorators.csrf import csrf_protect

from .forms import ContactForm


def index(request):
    return render(request, 'index.html')


def thanks(request):
    return render(request, 'thanks.html')


@csrf_protect
def contact(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        # honeypot: if the hidden 'tel' field is filled, silently redirect
        if form.is_valid() and form.cleaned_data.get('tel') != '':
            return redirect('thanks')

    form = ContactForm()
    return render(request, 'contact.html', {'form': form})


@csrf_protect
def contact_submit(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)

        if form.is_valid():
            try:
                EmailMessage(
                    subject=f"Contact: {form.cleaned_data['name']}",
                    body=form.cleaned_data['msg'],
                    from_email=settings.DEFAULT_FROM_EMAIL,
                    to=[settings.CONTACT_RECIPIENT_EMAIL],
                    reply_to=[form.cleaned_data['email']],
                ).send(fail_silently=True)
            except Exception as e:
                print(e)
            return redirect('thanks')
    else:
        form = ContactForm()

    return render(request, 'contact.html', {'form': form})
