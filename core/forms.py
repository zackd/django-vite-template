from django import forms


class ContactForm(forms.Form):
    name = forms.CharField(
        max_length=100,
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'id': 'name',
            'placeholder': 'John Smith',
        }),
        label='Full name',
    )
    tel = forms.CharField(
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'id': 'tel',
            'placeholder': '(phone)',
        }),
        label='Phone number',
        required=False  # Honeypot field - should be empty
    )
    email = forms.EmailField(
        widget=forms.EmailInput(attrs={
            'class': 'form-control',
            'id': 'email',
            'placeholder': 'name@example.com',
        }),
        label='Email address',
    )
    msg = forms.CharField(
        widget=forms.Textarea(attrs={
            'class': 'form-control',
            'id': 'msg',
            'rows': '3',
            'style': 'height: 100px',
            'placeholder': 'Your message',
        }),
        label='Message',
    )
