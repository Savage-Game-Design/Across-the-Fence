from typing import Protocol

class Explainable(Protocol):
    def explain(self) -> str:
        pass
