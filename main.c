#include <stdio.h>
#include <string.h>

#define MSG "alesurbanek"  // Jméno a příjmení bez diakritiky
#define KEY "urb"          // První tři písmena příjmení
#define ALPHABET_SIZE 26   // Počet písmen v anglické abecedě
#define ASCII_A 97         // ASCII hodnota 'a'

int main() {
  char cipher_text[31];  // Maximální délka zprávy je 30 znaků + 1 pro '\0'

  int msg_len = strlen(MSG);
  int key_len = strlen(KEY);
  int direction = 1;  // Střídání směru: 1 = vpřed, -1 = vzad

  for (int i = 0; i < msg_len; i++) {
    int msg_char = MSG[i] - ASCII_A;                // Aktuální znak zprávy jako index (0-25)
    int key_char = KEY[i % key_len] - ASCII_A + 1;  // Hodnota posunu (1-26)

    // Výpočet posunu podle směru
    int shift = direction * key_char;
    int new_char = (msg_char + shift + ALPHABET_SIZE) % ALPHABET_SIZE;  // Cyklický posuv
    cipher_text[i] = new_char + ASCII_A;                                // Převod na znak 'a'-'z'

    // Střídání směru posunu
    direction *= -1;
  }

  cipher_text[msg_len] = '\0';  // Ukončení řetězce nulovým znakem

  // Výpis zašifrované zprávy
  printf("Zašifrovaný text: %s\n", cipher_text);

  return 0;
}