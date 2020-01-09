#!/bin/sh

# Define output file. Change "$PROJECT_DIR/Tests" to your test's root source folder, if it's not the default name.
PROJECT_DIR="."
PODS_ROOT="$PROJECT_DIR/Pods"
OUTPUT_FILE="$PROJECT_DIR/StockMarketTradingTests/GeneratedMocks.swift"
echo "Generated Mocks File = $OUTPUT_FILE"

# Define input directory. Change "$PROJECT_DIR" to your project's root source folder, if it's not the default name.
INPUT_DIR="$PROJECT_DIR/StockMarketTrading"
echo "Mocks Input Directory = $INPUT_DIR"

# Generate mock files, include as many input files as you'd like to create mocks for.
${PODS_ROOT}/Cuckoo/run generate --testable "StockMarketTrading" \
--output "${OUTPUT_FILE}" \
"$INPUT_DIR/Networking/WebService.swift" \
"$INPUT_DIR/APIWrappers/PaymentsNetwork.swift" \
"$INPUT_DIR/Utility/PaymentValidation/PaymentValidation.swift" \

# ... and so forth
