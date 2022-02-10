['/*\n', '  Copyright 2019,2020 StarkWare Industries Ltd.\n', '\n', '  Licensed under the Apache License, Version 2.0 (the "License").\n', '  You may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '\n', '  https://www.starkware.co/open-source-license/\n', '\n', '  Unless required by applicable law or agreed to in writing,\n', '  software distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions\n', '  and limitations under the License.\n', '*/\n', 'pragma solidity ^0.6.11;\n', '\n', 'import "Finalizable.sol";\n', 'import "GpsFactRegistryAdapter.sol";\n', 'import "IQueryableFactRegistry.sol";\n', '\n', '/**\n', '  A finalizable version of GpsFactRegistryAdapter.\n', '  It allows resetting the gps program hash, until finalized.\n', '*/\n', 'contract FinalizableGpsFactAdapter is GpsFactRegistryAdapter , Finalizable {\n', '\n', '    constructor(IQueryableFactRegistry gpsStatementContract, uint256 programHash_)\n', '        public\n', '        GpsFactRegistryAdapter(gpsStatementContract, programHash_)\n', '    {\n', '    }\n', '\n', '    function setProgramHash(uint256 newProgramHash)\n', '        external\n', '        notFinalized\n', '        onlyAdmin\n', '    {\n', '        programHash = newProgramHash;\n', '    }\n', '\n', '    function identify() external override pure returns (string memory) {\n', '        return "StarkWare_FinalizableGpsFactAdapterForTesting_2021_1";\n', '    }\n', '}']