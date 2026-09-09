const io = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); }
  });
}, { threshold: .16 });

const contactFormHandler = (e: SubmitEvent) => {
  e.preventDefault();

  const tel = document.getElementById('tel') as HTMLInputElement;
  const form = tel?.form

  if (!tel || !form) return;

  if (tel.value == '') {
     form.action = "/contact_submit/"
  }
  
  form.submit();
};

// 

window.onload = () => {
  document.querySelectorAll('.reveal').forEach(el => io.observe(el));
  
  const contactForm = document.getElementById('contactForm') as HTMLElement;
  contactForm?.addEventListener('submit', contactFormHandler);
}