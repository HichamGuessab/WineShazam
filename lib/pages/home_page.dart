import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/88813a3f-5c1c-44a6-857a-d91c89bc705c/d7dzt09-1536bc52-acd0-4229-be32-e2a1712dc58b.gif?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzg4ODEzYTNmLTVjMWMtNDRhNi04NTdhLWQ5MWM4OWJjNzA1Y1wvZDdkenQwOS0xNTM2YmM1Mi1hY2QwLTQyMjktYmUzMi1lMmExNzEyZGM1OGIuZ2lmIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.ZFf02q1riSkMcP-d6ZxKhPu9HtCjMT_pu-nZqBemJ4k'),
            const SizedBox(height: 120),
            const Text(
              "WineShazam",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
    );
  }
}
