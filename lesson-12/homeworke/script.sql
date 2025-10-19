
import threading

# Function to check if a number is prime
def is_prime(n):
    if n < 2:
        return False
    for i in range(2, int(n ** 0.5) + 1):
        if n % i == 0:
            return False
    return True

# Thread function to check primes in a given range
def check_primes(start, end, result_list):
    for num in range(start, end + 1):
        if is_prime(num):
            result_list.append(num)

# Main program
if __name__ == "__main__":
    start_range = 1
    end_range = 100
    num_threads = 4
    threads = []
    primes = []

    # Calculate range for each thread
    step = (end_range - start_range + 1) // num_threads

    for i in range(num_threads):
        start = start_range + i * step
        end = start + step - 1 if i < num_threads - 1 else end_range
        thread = threading.Thread(target=check_primes, args=(start, end, primes))
        threads.append(thread)
        thread.start()

    # Wait for all threads to finish
    for thread in threads:
        thread.join()

    # Sort results since threads might append in random order
    primes.sort()
    print("Prime numbers:", primes)


import threading
from collections import Counter

def count_words(lines, result_list):
    word_count = Counter()
    for line in lines:
        words = line.strip().split()
        word_count.update(words)
    result_list.append(word_count)

if __name__ == "__main__":
    filename = "large_text.txt"
    num_threads = 4
    threads = []
    results = []

    # Read all lines once
    with open(filename, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # Split file lines for each thread
    chunk_size = len(lines) // num_threads
    for i in range(num_threads):
        start = i * chunk_size
        end = (i + 1) * chunk_size if i < num_threads - 1 else len(lines)
        thread = threading.Thread(target=count_words, args=(lines[start:end], results))
        threads.append(thread)
        thread.start()

    # Wait for threads to finish
    for thread in threads:
        thread.join()

    # Combine all thread results
    total_count = Counter()
    for partial_count in results:
        total_count.update(partial_count)

    # Print top 10 most common words
    print("Top 10 words:")
    for word, count in total_count.most_common(10):
        print(f"{word}: {count}")
