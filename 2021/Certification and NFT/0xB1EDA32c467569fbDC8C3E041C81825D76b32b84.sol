['/*\n', '  Copyright 2019,2020 StarkWare Industries Ltd.\n', '\n', '  Licensed under the Apache License, Version 2.0 (the "License").\n', '  You may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '\n', '  https://www.starkware.co/open-source-license/\n', '\n', '  Unless required by applicable law or agreed to in writing,\n', '  software distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions\n', '  and limitations under the License.\n', '*/\n', '// SPDX-License-Identifier: Apache-2.0.\n', 'pragma solidity ^0.6.11;\n', '\n', 'import "CairoBootloaderProgram.sol";\n', 'import "CairoVerifierContract.sol";\n', 'import "CpuPublicInputOffsets.sol";\n', 'import "MemoryPageFactRegistry.sol";\n', 'import "Identity.sol";\n', 'import "PrimeFieldElement0.sol";\n', 'import "GpsOutputParser.sol";\n', '\n', 'contract GpsStatementVerifier is\n', '        GpsOutputParser, Identity, CairoBootloaderProgramSize, PrimeFieldElement0 {\n', '    CairoBootloaderProgram bootloaderProgramContractAddress;\n', '    MemoryPageFactRegistry memoryPageFactRegistry;\n', '    CairoVerifierContract[] cairoVerifierContractAddresses;\n', '\n', '    uint256 internal constant N_MAIN_ARGS = 5;\n', '    uint256 internal constant N_MAIN_RETURN_VALUES = 5;\n', '    uint256 internal constant N_BUILTINS = 4;\n', '\n', '    /*\n', '      Constructs an instance of GpsStatementVerifier.\n', '      bootloaderProgramContract is the address of the bootloader program contract\n', '      and cairoVerifierContracts is a list of cairoVerifiers indexed by their id.\n', '    */\n', '    constructor(\n', '        address bootloaderProgramContract,\n', '        address memoryPageFactRegistry_,\n', '        address[] memory cairoVerifierContracts)\n', '        public\n', '    {\n', '        bootloaderProgramContractAddress = CairoBootloaderProgram(bootloaderProgramContract);\n', '        memoryPageFactRegistry = MemoryPageFactRegistry(memoryPageFactRegistry_);\n', '        cairoVerifierContractAddresses = new CairoVerifierContract[](cairoVerifierContracts.length);\n', '        for (uint256 i = 0; i < cairoVerifierContracts.length; ++i) {\n', '            cairoVerifierContractAddresses[i] = CairoVerifierContract(cairoVerifierContracts[i]);\n', '        }\n', '    }\n', '\n', '    function identify()\n', '        external pure override\n', '        returns(string memory)\n', '    {\n', '        return "StarkWare_GpsStatementVerifier_2020_1";\n', '    }\n', '\n', '    /*\n', '      Verifies a proof and registers the corresponding facts.\n', '      For the structure of cairoAuxInput, see cpu/CpuPublicInputOffsets.sol.\n', '      taskMetadata is structured as follows:\n', '      1. Number of tasks.\n', '      2. For each task:\n', '         1. Task output size (including program hash and size).\n', '         2. Program hash.\n', '    */\n', '    function verifyProofAndRegister(\n', '        uint256[] calldata proofParams,\n', '        uint256[] calldata proof,\n', '        uint256[] calldata taskMetadata,\n', '        uint256[] calldata cairoAuxInput,\n', '        uint256 cairoVerifierId\n', '    )\n', '        external\n', '    {\n', '        require(\n', '            cairoAuxInput.length > OFFSET_N_PUBLIC_MEMORY_PAGES,\n', '            "Invalid cairoAuxInput length.");\n', '        uint256 nPages = cairoAuxInput[OFFSET_N_PUBLIC_MEMORY_PAGES];\n', '        require(\n', '            cairoAuxInput.length == getPublicInputLength(nPages) + /*z and alpha*/ 2,\n', '            "Invalid cairoAuxInput length.");\n', '\n', '        // The values z and alpha are used only for the fact registration of the main page.\n', '        // They are not needed in the auxiliary input of CpuVerifier as they are computed there.\n', '        // Create a copy of cairoAuxInput without z and alpha.\n', '        uint256[] memory cairoPublicInput = new uint256[](cairoAuxInput.length - /*z and alpha*/ 2);\n', '        for (uint256 i = 0; i < cairoAuxInput.length - /*z and alpha*/ 2; i++) {\n', '            cairoPublicInput[i] = cairoAuxInput[i];\n', '        }\n', '\n', '        {\n', '        // Process public memory.\n', '        (uint256 publicMemoryLength, uint256 memoryHash, uint256 prod) =\n', '            registerPublicMemoryMainPage(taskMetadata, cairoAuxInput);\n', '\n', '        // Make sure the first page is valid.\n', '        // If the size or the hash are invalid, it may indicate that there is a mismatch between the\n', '        // bootloader program contract and the program in the proof.\n', '        require(\n', '            cairoAuxInput[getOffsetPageSize(0)] == publicMemoryLength,\n', '            "Invalid size for memory page 0.");\n', '        require(\n', '            cairoAuxInput[getOffsetPageHash(0)] == memoryHash,\n', '            "Invalid hash for memory page 0.");\n', '        require(\n', '            cairoAuxInput[getOffsetPageProd(0, nPages)] == prod,\n', '            "Invalid cumulative product for memory page 0.");\n', '        }\n', '\n', '        require(\n', '            cairoVerifierId < cairoVerifierContractAddresses.length,\n', '            "cairoVerifierId is out of range.");\n', '\n', '        // NOLINTNEXTLINE: reentrancy-benign.\n', '        cairoVerifierContractAddresses[cairoVerifierId].verifyProofExternal(\n', '            proofParams, proof, cairoPublicInput);\n', '\n', '        registerGpsFacts(taskMetadata, cairoAuxInput);\n', '    }\n', '\n', '    /*\n', '      Registers the fact for memory page 0, which includes:\n', '      1. The bootloader program,\n', '      2. Arguments and return values of main()\n', '      3. Some of the data required for computing the task facts. which is represented in\n', '         taskMetadata.\n', '      Returns information on the registered fact.\n', '\n', '      Assumptions: cairoAuxInput is connected to the public input, which is verified by\n', '      cairoVerifierContractAddresses.\n', '      Guarantees: taskMetadata is consistent with the public memory, with some sanity checks.\n', '    */\n', '    function registerPublicMemoryMainPage(\n', '        uint256[] memory taskMetadata,\n', '        uint256[] memory cairoAuxInput\n', '    ) internal returns (uint256 publicMemoryLength, uint256 memoryHash, uint256 prod) {\n', '        uint256 nTasks = taskMetadata[0];\n', '        require(nTasks < 2**30, "Invalid number of tasks.");\n', '\n', '        // Public memory length.\n', '        publicMemoryLength = (\n', '            PROGRAM_SIZE + N_MAIN_ARGS + N_MAIN_RETURN_VALUES + /*Number of tasks cell*/1 +\n', '            2 * nTasks);\n', '        uint256[] memory publicMemory = new uint256[](\n', '            N_WORDS_PER_PUBLIC_MEMORY_ENTRY * publicMemoryLength);\n', '\n', '        uint256 offset = 0;\n', '\n', '        // Write public memory, which is a list of pairs (address, value).\n', '        {\n', '        // Program segment.\n', '        uint256[PROGRAM_SIZE] memory bootloaderProgram =\n', '            bootloaderProgramContractAddress.getCompiledProgram();\n', '        for (uint256 i = 0; i < bootloaderProgram.length; i++) {\n', '            // Force that memory[i + INITIAL_PC] = bootloaderProgram[i].\n', '            publicMemory[offset] = i + INITIAL_PC;\n', '            publicMemory[offset + 1] = bootloaderProgram[i];\n', '            offset += 2;\n', '        }\n', '        }\n', '\n', '        {\n', "        // Execution segment - main's arguments.\n", '        uint256 executionBeginAddr = cairoAuxInput[OFFSET_EXECUTION_BEGIN_ADDR];\n', '        publicMemory[offset + 0] = executionBeginAddr - 5;\n', '        publicMemory[offset + 1] = cairoAuxInput[OFFSET_OUTPUT_BEGIN_ADDR];\n', '        publicMemory[offset + 2] = executionBeginAddr - 4;\n', '        publicMemory[offset + 3] = cairoAuxInput[OFFSET_PEDERSEN_BEGIN_ADDR];\n', '        publicMemory[offset + 4] = executionBeginAddr - 3;\n', '        publicMemory[offset + 5] = cairoAuxInput[OFFSET_RANGE_CHECK_BEGIN_ADDR];\n', '        publicMemory[offset + 6] = executionBeginAddr - 2;\n', '        publicMemory[offset + 7] = cairoAuxInput[OFFSET_ECDSA_BEGIN_ADDR];\n', '        publicMemory[offset + 8] = executionBeginAddr - 1;\n', '        publicMemory[offset + 9] = cairoAuxInput[OFFSET_CHECKPOINTS_BEGIN_PTR];\n', '        offset += 10;\n', '        }\n', '\n', '        {\n', '        // Execution segment - return values.\n', '        uint256 executionStopPtr = cairoAuxInput[OFFSET_EXECUTION_STOP_PTR];\n', '        publicMemory[offset + 0] = executionStopPtr - 5;\n', '        publicMemory[offset + 1] = cairoAuxInput[OFFSET_OUTPUT_STOP_PTR];\n', '        publicMemory[offset + 2] = executionStopPtr - 4;\n', '        publicMemory[offset + 3] = cairoAuxInput[OFFSET_PEDERSEN_STOP_PTR];\n', '        publicMemory[offset + 4] = executionStopPtr - 3;\n', '        publicMemory[offset + 5] = cairoAuxInput[OFFSET_RANGE_CHECK_STOP_PTR];\n', '        publicMemory[offset + 6] = executionStopPtr - 2;\n', '        publicMemory[offset + 7] = cairoAuxInput[OFFSET_ECDSA_STOP_PTR];\n', '        publicMemory[offset + 8] = executionStopPtr - 1;\n', '        publicMemory[offset + 9] = cairoAuxInput[OFFSET_CHECKPOINTS_STOP_PTR];\n', '        offset += 10;\n', '        }\n', '\n', '        // Program output.\n', '        {\n', '        // Check that there are enough range checks for the bootloader builtin validation.\n', '        // Each builtin is validated for each task and each validation uses one range check.\n', '        require(\n', '            cairoAuxInput[OFFSET_RANGE_CHECK_STOP_PTR] >=\n', '            cairoAuxInput[OFFSET_RANGE_CHECK_BEGIN_ADDR] + N_BUILTINS * nTasks,\n', '            "Range-check stop pointer should be after all range checks used for validations.");\n', '        // The checkpoint builtin is used once for each task, taking up two cells.\n', '        require(\n', '            cairoAuxInput[OFFSET_CHECKPOINTS_STOP_PTR] >=\n', '            cairoAuxInput[OFFSET_CHECKPOINTS_BEGIN_PTR] + 2 * nTasks,\n', '            "Number of checkpoints should be at least the number of tasks.");\n', '\n', '        uint256 outputAddress = cairoAuxInput[OFFSET_OUTPUT_BEGIN_ADDR];\n', '        // Force that memory[outputAddress] = nTasks.\n', '        publicMemory[offset + 0] = outputAddress;\n', '        publicMemory[offset + 1] = nTasks;\n', '        offset += 2;\n', '        outputAddress += 1;\n', '        uint256 taskMetadataOffset = METADATA_TASKS_OFFSET;\n', '\n', '        for (uint256 task = 0; task < nTasks; task++) {\n', '            uint256 outputSize = taskMetadata[\n', '                taskMetadataOffset + METADATA_OFFSET_TASK_OUTPUT_SIZE];\n', '            require(2 <= outputSize && outputSize < 2**30, "Invalid task output size.");\n', '            uint256 programHash = taskMetadata[\n', '                taskMetadataOffset + METADATA_OFFSET_TASK_PROGRAM_HASH];\n', '            uint256 nTreePairs = taskMetadata[\n', '                taskMetadataOffset + METADATA_OFFSET_TASK_N_TREE_PAIRS];\n', '            require(\n', '                1 <= nTreePairs && nTreePairs < 2**20,\n', '                "Invalid number of pairs in the Merkle tree structure.");\n', '            // Force that memory[outputAddress] = outputSize.\n', '            publicMemory[offset + 0] = outputAddress;\n', '            publicMemory[offset + 1] = outputSize;\n', '            // Force that memory[outputAddress + 1] = programHash.\n', '            publicMemory[offset + 2] = outputAddress + 1;\n', '            publicMemory[offset + 3] = programHash;\n', '            offset += 4;\n', '            outputAddress += outputSize;\n', '            taskMetadataOffset += METADATA_TASK_HEADER_SIZE + 2 * nTreePairs;\n', '        }\n', '        require(taskMetadata.length == taskMetadataOffset, "Invalid length of taskMetadata.");\n', '\n', '        require(\n', '            cairoAuxInput[OFFSET_OUTPUT_STOP_PTR] == outputAddress,\n', '            "Inconsistent program output length.");\n', '        }\n', '\n', '        require(publicMemory.length == offset, "Not all Cairo public inputs were written.");\n', '\n', '        bytes32 factHash;\n', '        (factHash, memoryHash, prod) = memoryPageFactRegistry.registerRegularMemoryPage(\n', '            publicMemory,\n', '            /*z=*/cairoAuxInput[cairoAuxInput.length - 2],\n', '            /*alpha=*/cairoAuxInput[cairoAuxInput.length - 1],\n', '            K_MODULUS);\n', '    }\n', '}']