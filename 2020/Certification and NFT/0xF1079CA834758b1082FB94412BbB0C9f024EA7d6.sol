['// hevm: flattened sources of src/DssSpell.sol\n', 'pragma solidity =0.5.12 >0.4.13 >=0.4.23 >=0.5.12;\n', '\n', '////// lib/dss-interfaces/src/dapp/DSPauseAbstract.sol\n', '/* pragma solidity >=0.5.12; */\n', '\n', '// https://github.com/dapphub/ds-pause\n', 'interface DSPauseAbstract {\n', '    function setOwner(address) external;\n', '    function setAuthority(address) external;\n', '    function setDelay(uint256) external;\n', '    function plans(bytes32) external view returns (bool);\n', '    function proxy() external view returns (address);\n', '    function delay() external view returns (uint256);\n', '    function plot(address, bytes32, bytes calldata, uint256) external;\n', '    function drop(address, bytes32, bytes calldata, uint256) external;\n', '    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);\n', '}\n', '\n', '////// lib/dss-interfaces/src/dss/FlipperMomAbstract.sol\n', '/* pragma solidity >=0.5.12; */\n', '\n', '// https://github.com/makerdao/flipper-mom/blob/master/src/FlipperMom.sol\n', 'interface FlipperMomAbstract {\n', '    function owner() external returns (address);\n', '    function setOwner(address) external;\n', '    function authority() external returns (address);\n', '    function setAuthority(address) external;\n', '    function cat() external returns (address);\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '}\n', '\n', '////// lib/dss-interfaces/src/dss/OsmMomAbstract.sol\n', '/* pragma solidity >=0.5.12; */\n', '\n', '\n', '// https://github.com/makerdao/osm-mom\n', 'interface OsmMomAbstract {\n', '    function owner() external view returns (address);\n', '    function authority() external view returns (address);\n', '    function osms(bytes32) external view returns (address);\n', '    function setOsm(bytes32, address) external;\n', '    function setOwner(address) external;\n', '    function setAuthority(address) external;\n', '    function stop(bytes32) external;\n', '}\n', '\n', '////// src/DssSpell.sol\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity 0.5.12; */\n', '\n', '/* import "lib/dss-interfaces/src/dapp/DSPauseAbstract.sol"; */\n', '/* import "lib/dss-interfaces/src/dss/OsmMomAbstract.sol"; */\n', '/* import "lib/dss-interfaces/src/dss/FlipperMomAbstract.sol"; */\n', '\n', 'contract SpellAction {\n', '    // MAINNET ADDRESSES\n', '    //\n', '    // The contracts in this list should correspond to MCD core contracts, verify\n', '    //  against the current release list at:\n', '    //     https://changelog.makerdao.com/releases/mainnet/1.1.3/contracts.json\n', '\n', '    address constant FLIPPER_MOM = 0xc4bE7F74Ee3743bDEd8E0fA218ee5cf06397f472;\n', '    address constant MCD_PAUSE   = 0xbE286431454714F511008713973d3B053A2d38f3;\n', '    address constant OSM_MOM     = 0x76416A4d5190d071bfed309861527431304aA14f;\n', '\n', '    // Decimals & precision\n', '    uint256 constant THOUSAND = 10 ** 3;\n', '    uint256 constant MILLION  = 10 ** 6;\n', '    uint256 constant WAD      = 10 ** 18;\n', '    uint256 constant RAY      = 10 ** 27;\n', '    uint256 constant RAD      = 10 ** 45;\n', '\n', '    // Many of the settings that change weekly rely on the rate accumulator\n', '    // described at https://docs.makerdao.com/smart-contract-modules/rates-module\n', '    // To check this yourself, use the following rate calculation (example 8%):\n', '    //\n', "    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'\n", '    //\n', '    // A table of rates can be found at\n', '    //    https://ipfs.io/ipfs/QmefQMseb3AiTapiAKKexdKHig8wroKuZbmLtPLv4u2YwW\n', '\n', '    function execute() external {\n', '        // increase governance delay to 72 hours\n', '        DSPauseAbstract(MCD_PAUSE).setDelay(72 hours);\n', '\n', '        // remove authority from the FlipperMom\n', '        FlipperMomAbstract(FLIPPER_MOM).setAuthority(address(0));\n', '\n', '        // remove authority from the OsmMom\n', '        OsmMomAbstract(OSM_MOM).setAuthority(address(0));\n', '    }\n', '}\n', '\n', 'contract DssSpell {\n', '    DSPauseAbstract public pause =\n', '        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);\n', '    address         public action;\n', '    bytes32         public tag;\n', '    uint256         public eta;\n', '    bytes           public sig;\n', '    uint256         public expiration;\n', '    bool            public done;\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/32eab726f883b00c500cfc288612ec0fe696c7da/governance/votes/Executive%20vote%20-%20October%2030%2C%202020.md -q -O - 2>/dev/null)"\n', '    string constant public description =\n', '        "2020-10-30 MakerDAO Executive Spell | Hash: 0x458b4e4acf4055bac448d17cafcfa847f5d721f7894fe8a34f0fc8479a1ec645";\n', '\n', '    constructor() public {\n', '        sig = abi.encodeWithSignature("execute()");\n', '        action = address(new SpellAction());\n', '        bytes32 _tag;\n', '        address _action = action;\n', '        assembly { _tag := extcodehash(_action) }\n', '        tag = _tag;\n', '        expiration = now + 30 days;\n', '    }\n', '\n', '    modifier officeHours {\n', '        uint day = (now / 1 days + 3) % 7;\n', '        require(day < 5, "Can only be cast on a weekday");\n', '        uint hour = now / 1 hours % 24;\n', '        require(hour >= 14 && hour < 21, "Outside office hours");\n', '        _;\n', '    }\n', '\n', '    function schedule() public {\n', '        require(now <= expiration, "This contract has expired");\n', '        require(eta == 0, "This spell has already been scheduled");\n', '        eta = now + DSPauseAbstract(pause).delay();\n', '        pause.plot(action, tag, sig, eta);\n', '    }\n', '\n', '    function cast() public /* officeHours */ {\n', '        require(!done, "spell-already-cast");\n', '        done = true;\n', '        pause.exec(action, tag, sig, eta);\n', '    }\n', '}']