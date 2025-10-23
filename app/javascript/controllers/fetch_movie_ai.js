document.addEventListener('turbo:load', () => {
  const btn = document.getElementById('fetch_movie_ai_btn');
  const titleInput = document.getElementById('movie_title');

  if (!btn) return; // se a página não tiver o botão, sai

  console.log("JS carregou"); // agora deve aparecer

  btn.addEventListener('click', async () => {
    const title = titleInput.value.trim();
    if (!title) {
      alert('Digite o título do filme antes de buscar.');
      return;
    }

    btn.disabled = true;
    btn.textContent = 'Buscando...';

    try {
      const response = await fetch('/dashboard/movies/fetch_movie_data_ai', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ title })
      });
      const data = await response.json();

      if (data.success) {
        document.getElementById('movie_synopsis').value = data.movie.synopsis || '';
        document.getElementById('movie_release_year').value = data.movie.release_year || '';
        document.getElementById('movie_duration').value = data.movie.duration || '';
        document.getElementById('movie_director').value = data.movie.director || '';
      } else {
        alert('Não foi possível obter as informações do filme.');
      }
    } catch (error) {
      alert('Erro ao buscar informações.');
      console.error(error);
    } finally {
      btn.disabled = false;
      btn.textContent = 'Buscar com IA';
    }
  });
});
