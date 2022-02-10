['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-24\n', '*/\n', '\n', '// hevm: flattened sources of src/DssSpell.sol\n', '// SPDX-License-Identifier: AGPL-3.0-or-later\n', 'pragma solidity =0.6.12 >=0.6.12 <0.7.0;\n', '\n', '////// lib/dss-exec-lib/src/DssExecLib.sol\n', '//\n', '// DssExecLib.sol -- MakerDAO Executive Spellcrafting Library\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '/* pragma solidity ^0.6.12; */\n', '/* pragma experimental ABIEncoderV2; */\n', '\n', '\n', 'library DssExecLib {\n', '    function canCast(uint40, bool) public pure returns (bool) {}\n', '    function nextCastTime(uint40, uint40, bool) public pure returns (uint256) {}\n', '    function sendPaymentFromSurplusBuffer(address, uint256) public {}\n', '}\n', '\n', '////// lib/dss-exec-lib/src/DssAction.sol\n', '//\n', '// DssAction.sol -- DSS Executive Spell Actions\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.6.12; */\n', '\n', '/* import { DssExecLib } from "./DssExecLib.sol"; */\n', '\n', 'abstract contract DssAction {\n', '\n', '    using DssExecLib for *;\n', '\n', '    // Modifier used to limit execution time when office hours is enabled\n', '    modifier limited {\n', '        require(DssExecLib.canCast(uint40(block.timestamp), officeHours()), "Outside office hours");\n', '        _;\n', '    }\n', '\n', '    // Office Hours defaults to true by default.\n', '    //   To disable office hours, override this function and\n', '    //    return false in the inherited action.\n', '    function officeHours() public virtual returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    // DssExec calls execute. We limit this function subject to officeHours modifier.\n', '    function execute() external limited {\n', '        actions();\n', '    }\n', '\n', '    // DssAction developer must override `actions()` and place all actions to be called inside.\n', '    //   The DssExec function will call this subject to the officeHours limiter\n', '    //   By keeping this function public we allow simulations of `execute()` on the actions outside of the cast time.\n', '    function actions() public virtual;\n', '\n', '    // Returns the next available cast time\n', '    function nextCastTime(uint256 eta) external returns (uint256 castTime) {\n', '        require(eta <= uint40(-1));\n', '        castTime = DssExecLib.nextCastTime(uint40(eta), uint40(block.timestamp), officeHours());\n', '    }\n', '}\n', '\n', '////// lib/dss-exec-lib/src/DssExec.sol\n', '//\n', '// DssExec.sol -- MakerDAO Executive Spell Template\n', '//\n', '// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity ^0.6.12; */\n', '\n', 'interface PauseAbstract {\n', '    function delay() external view returns (uint256);\n', '    function plot(address, bytes32, bytes calldata, uint256) external;\n', '    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);\n', '}\n', '\n', 'interface Changelog {\n', '    function getAddress(bytes32) external view returns (address);\n', '}\n', '\n', 'interface SpellAction {\n', '    function officeHours() external view returns (bool);\n', '    function nextCastTime(uint256) external view returns (uint256);\n', '}\n', '\n', 'contract DssExec {\n', '\n', '    Changelog      constant public log   = Changelog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);\n', '    uint256                 public eta;\n', '    bytes                   public sig;\n', '    bool                    public done;\n', '    bytes32       immutable public tag;\n', '    address       immutable public action;\n', '    uint256       immutable public expiration;\n', '    PauseAbstract immutable public pause;\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://<executive-vote-canonical-post> -q -O - 2>/dev/null)"\n', '    string                  public description;\n', '\n', '    function officeHours() external view returns (bool) {\n', '        return SpellAction(action).officeHours();\n', '    }\n', '\n', '    function nextCastTime() external view returns (uint256 castTime) {\n', '        return SpellAction(action).nextCastTime(eta);\n', '    }\n', '\n', '    // @param _description  A string description of the spell\n', '    // @param _expiration   The timestamp this spell will expire. (Ex. now + 30 days)\n', '    // @param _spellAction  The address of the spell action\n', '    constructor(string memory _description, uint256 _expiration, address _spellAction) public {\n', '        pause       = PauseAbstract(log.getAddress("MCD_PAUSE"));\n', '        description = _description;\n', '        expiration  = _expiration;\n', '        action      = _spellAction;\n', '\n', '        sig = abi.encodeWithSignature("execute()");\n', '        bytes32 _tag;                    // Required for assembly access\n', '        address _action = _spellAction;  // Required for assembly access\n', '        assembly { _tag := extcodehash(_action) }\n', '        tag = _tag;\n', '    }\n', '\n', '    function schedule() public {\n', '        require(now <= expiration, "This contract has expired");\n', '        require(eta == 0, "This spell has already been scheduled");\n', '        eta = now + PauseAbstract(pause).delay();\n', '        pause.plot(action, tag, sig, eta);\n', '    }\n', '\n', '    function cast() public {\n', '        require(!done, "spell-already-cast");\n', '        done = true;\n', '        pause.exec(action, tag, sig, eta);\n', '    }\n', '}\n', '\n', '////// src/DssSpell.sol\n', '// Copyright (C) 2021 Maker Ecosystem Growth Holdings, INC.\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity 0.6.12; */\n', '\n', '/* import "dss-exec-lib/DssExec.sol"; */\n', '/* import "dss-exec-lib/DssAction.sol"; */\n', '\n', 'contract DssSpellAction is DssAction {\n', '\n', '    // Provides a descriptive tag for bot consumption\n', '    // This should be modified weekly to provide a summary of the actions\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/eae06d4b38346a7d90d92cd951beff16a3d548c9/governance/votes/Executive%20vote%20-%20May%2024%2C%202021.md -q -O - 2> /dev/null)"\n', '    string public constant description =\n', '        "2021-05-24 MakerDAO Executive Spell | Hash: 0xca4176704005e00b4357c0ef4ebb1812c88b21e57463bdfbb90da1c8189b406d";\n', '\n', '    // SES auditors Multisig\n', '    address constant SES_AUDITORS_MULTISIG = 0x87AcDD9208f73bFc9207e1f6F0fDE906bcA95cc6;\n', '    // Monthly expenses\n', '    uint256 constant SES_AUDITORS_AMOUNT = 1_153_480;\n', '\n', '    // MIP50: Direct Deposit Module\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/c23fd23b340ecf66a16f0e1ecfe7b55a5232864d/MIP50/mip50.md -q -O - 2> /dev/null)"\n', '    string constant public MIP50 = "0xb6ba98197a58fab2af683951e753dfac802e0fef29d736ef58dd91a35706fb61";\n', '\n', '    // MIP51: Monthly Governance Cycle\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/c23fd23b340ecf66a16f0e1ecfe7b55a5232864d/MIP51/mip51.md -q -O - 2> /dev/null)"\n', '    string constant public MIP51 = "0xa9e81bc611853444ebfe5e3cca2f14b48a8490612ed4077ba7aa52a302db2366";\n', '\n', '    // MIP4c2-SP14: MIP Amendment Subproposals\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/c23fd23b340ecf66a16f0e1ecfe7b55a5232864d/MIP4/MIP4c2-Subproposals/MIP4c2-SP14.md -q -O - 2> /dev/null)"\n', '    string constant public MIP4c2SP14 = "0x466c906898858488c5083ef8e9d67bf5c26e86c372064bd483de3a203285b1a2";\n', '\n', '    // MIP39c2-SP10: Adding Sustainable Ecosystem Scaling Core Unit\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/c23fd23b340ecf66a16f0e1ecfe7b55a5232864d/MIP39/MIP39c2-Subproposals/MIP39c2-SP10.md -q -O - 2> /dev/null)"\n', '    string constant public MIP39c2SP10 = "0x29b327498fe5b300cd0f81b2fa0eacd886916162b188b967fb5bb330f5b68b94";\n', '\n', '    // MIP40c3-SP10: Modify Core Unit Budget\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/c23fd23b340ecf66a16f0e1ecfe7b55a5232864d/MIP40/MIP40c3-Subproposals/MIP40c3-SP10.md -q -O - 2> /dev/null)"\n', '    string constant public MIP40c3SP10 = "0xa3afb63a4710cb30ad67082cdbb8156a11b315cadb251bfe6af7732c08303aa6";\n', '\n', '    // MIP41c4-SP10: Facilitator Onboarding (Subproposal Process) Template\n', '    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/mips/c23fd23b340ecf66a16f0e1ecfe7b55a5232864d/MIP41/MIP41c4-Subproposals/MIP41c4-SP10.md -q -O - 2> /dev/null)"\n', '    string constant public MIP41c4SP10 = "0xe37c37e3ffc8a2c638500f05f179b1d07d00e5aa35ae37ac88a1e10d43e77728";\n', '\n', '    // Disable Office Hours\n', '    function officeHours() public override returns (bool) {\n', '        return false;\n', '    }\n', '\n', '    function actions() public override {\n', '        // Payment of SES auditors budget\n', '        DssExecLib.sendPaymentFromSurplusBuffer(SES_AUDITORS_MULTISIG, SES_AUDITORS_AMOUNT);\n', '    }\n', '}\n', '\n', 'contract DssSpell is DssExec {\n', '    DssSpellAction internal action_ = new DssSpellAction();\n', '    constructor() DssExec(action_.description(), block.timestamp + 4 days, address(action_)) public {}\n', '}']