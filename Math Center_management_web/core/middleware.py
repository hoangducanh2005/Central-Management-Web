from django.shortcuts import redirect

class LoginRequiredMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        path = request.path_info
        if (
            not request.user.is_authenticated
            and path != '/'  # Loại trừ trang chủ vì đã có logic riêng
            and not path.startswith('/login')
            and not path.startswith('/logout')
            and not path.startswith('/static/')
            and not path.startswith('/media/')
        ):
            return redirect('core:login')
        response = self.get_response(request)
        return response