import pyzx as zx
from fractions import Fraction

# Create a one-qubit quantum circuit
circuit = zx.Circuit(1)

# Add two Z-phase gates with phase pi/4 to qubit 0
circuit.add_gate("ZPhase", 0, phase=Fraction(1, 4))
circuit.add_gate("ZPhase", 0, phase=Fraction(1, 4))

# Convert the circuit to a ZX diagram
original = circuit.to_graph()

# Copy and simplify the diagram
simplified = original.copy()
zx.simplify.full_reduce(simplified)

# Extract a quantum circuit from the simplified ZX diagram
simplified_circuit = zx.extract_circuit(simplified.copy())

# Print the results
print("Original circuit:")
print(circuit.stats())

print("Vertices before simplification:", original.num_vertices())
print("Vertices after simplification:", simplified.num_vertices())

# Check whether simplification preserves the circuit's behavior
same = zx.compare_tensors(original, simplified)
print("Equivalent before and after simplification:", same)

# Print the simplified circuit in the terminal
print("\nSimplified circuit:")
print(simplified_circuit)
print(simplified_circuit.stats())

# Display the ZX diagrams before and after simplification
print("Showing the original ZX diagram...")
zx.draw(original, labels=True)

print("Showing the simplified ZX diagram...")
zx.draw(simplified, labels=True)
