['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-03\n', '*/\n', '\n', '// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '// SPDX-License-Identifier: GPL-3.0-only\n', 'pragma solidity ^0.8.3;\n', '\n', '/**\n', ' * @title Proxy\n', ' * @notice Basic proxy that delegates all calls to a fixed implementing contract.\n', ' * The implementing contract cannot be upgraded.\n', ' * @author Julien Niset - <[email\xa0protected]>\n', ' */\n', 'contract Proxy {\n', '\n', '    address immutable public implementation;\n', '\n', '    event Received(uint indexed value, address indexed sender, bytes data);\n', '\n', '    constructor(address _implementation) {\n', '        implementation = _implementation;\n', '    }\n', '\n', '    fallback() external payable {\n', '        address target = implementation;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            calldatacopy(0, 0, calldatasize())\n', '            let result := delegatecall(gas(), target, 0, calldatasize(), 0, 0)\n', '            returndatacopy(0, 0, returndatasize())\n', '            switch result\n', '            case 0 {revert(0, returndatasize())}\n', '            default {return (0, returndatasize())}\n', '        }\n', '    }\n', '\n', '    receive() external payable {\n', '        emit Received(msg.value, msg.sender, "");\n', '    }\n', '}']