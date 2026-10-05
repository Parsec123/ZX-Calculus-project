import pyzx as zx
from fractions import Fraction

# Create a one-qubit quantum circuit
circuit = zx.Circuit(1)

# ============================================================
# Edit this section to build the circuit you want to study
# ============================================================

def build_circuit():
    circuit = zx.Circuit(1)

    # Current example: H-Z(pi)-H
    circuit.add_gate("HAD", 0)
    circuit.add_gate(
        "ZPhase",
        0,
        phase=Fraction(1, 1),
    )
    circuit.add_gate("HAD", 0)

    return circuit

# ============================================================
# General analysis function: usually no changes needed
# ============================================================

def analyze_circuit(circuit, demo_name="ZX-calculus demo"):
    # Convert the original circuit to a ZX diagram
    original_graph = circuit.to_graph()

    # Simplify the diagram using ZX-calculus rules
    simplified_graph = original_graph.copy()
    zx.simplify.full_reduce(simplified_graph)

    # Check whether ZX simplification preserves the circuit's behavior
    equivalent_after_reduction = zx.compare_tensors(
        original_graph,
        simplified_graph,
    )

    # Extract a circuit from the simplified ZX graph
    try:
        extracted_circuit = zx.extract_circuit(
            simplified_graph.copy()
        )
    except ValueError as error:
        extracted_circuit = None
        optimized_circuit = None
        optimized_graph = None
        equivalent_after_optimization = None
        extraction_error = str(error)

    else:
        extraction_error = None

        # Apply circuit-level optimization to the extracted circuit
        optimized_circuit = zx.optimize.basic_optimization(
            extracted_circuit.copy()
        )

        # Convert the optimized circuit to a ZX diagram
        optimized_graph = optimized_circuit.to_graph()

        # Check whether the final optimized circuit is still equivalent
        equivalent_after_optimization = zx.compare_tensors(
            original_graph,
            optimized_graph,
        )

    # --------------------------------------------------------
    # Terminal output
    # --------------------------------------------------------

    print("=" * 60)
    print("Demo:", demo_name)
    print("=" * 60)

    print("\nOriginal circuit:")
    print(circuit)
    print("Gates:", circuit.gates)
    print(circuit.stats())

    print(
        "Vertices before simplification:",
        original_graph.num_vertices(),
    )

    print(
        "Vertices after simplification:",
        simplified_graph.num_vertices(),
    )

    print(
        "T-count before simplification:",
        zx.tcount(original_graph),
    )

    print(
        "T-count after simplification:",
        zx.tcount(simplified_graph),
    )

    print(
        "Equivalent after ZX reduction:",
        equivalent_after_reduction,
    )

    if extracted_circuit is not None:
        print("\nAutomatically extracted circuit:")
        print(extracted_circuit)
        print("Extracted gates:", extracted_circuit.gates)

        print("\nAutomatically optimized circuit:")
        print(optimized_circuit)
        print("Optimized gates:", optimized_circuit.gates)
        print(optimized_circuit.stats())

        print(
            "Equivalent after circuit optimization:",
            equivalent_after_optimization,
        )
    else:
        print("\nCircuit extraction failed:")
        print(extraction_error)

    # --------------------------------------------------------
    # Display the diagrams
    # --------------------------------------------------------

    print("\nShowing the original ZX diagram...")
    zx.draw(original_graph, labels=True)

    print("Showing the reduced graph-like diagram...")
    zx.draw(simplified_graph, labels=True)

    if optimized_graph is not None:
        print("Showing the automatically optimized diagram...")
        zx.draw(optimized_graph, labels=True)

    return {
        "original_graph": original_graph,
        "simplified_graph": simplified_graph,
        "extracted_circuit": extracted_circuit,
        "optimized_circuit": optimized_circuit,
        "optimized_graph": optimized_graph,
        "equivalent_after_reduction":
            equivalent_after_reduction,
        "equivalent_after_optimization":
            equivalent_after_optimization,
    }


# ============================================================
# Run the analysis
# ============================================================

circuit = build_circuit()

results = analyze_circuit(
    circuit,
    demo_name="Automatic circuit analysis",
)
