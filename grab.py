import subprocess
import multiprocessing
from time import perf_counter


results: dict[tuple[int, int], str]

def main():
    print("defense\tattack\ttime\texpected wounds\twounds>=1\twounds>=2\twounds>=3\twounds>=4\twounds>=5\twounds>=6\twounds>=7\twounds>=8\twounds>=9\twounds>=10",flush=True)
    with multiprocessing.Pool() as pool:
        for attack in range(1, 11):
            for output in pool.map(stuff, zip(range(1, 11), [attack] * 11)):
                print(output, flush=True)



def stuff(args: tuple[int, int]) -> str:
    defense, attack = args
    start = perf_counter()

    outputb: bytes = subprocess.check_output(["prism", "models/battles.pm", "models/battles.pctl", "-const", f"defense={defense},attack={attack}"])
    end = perf_counter()
    dt = end - start

    output: str = outputb.decode()

    result = f"{defense:2}\t{attack:2}\t{dt: 5.5f}"
    for line in output.splitlines():
        if line.startswith("Result"):
            i: int = 8
            j: int = line.index(" ", i)
            num = float(line[i:j])
            result += f"\t{num:2.10f}"

    return result


if __name__ == "__main__":
    main()