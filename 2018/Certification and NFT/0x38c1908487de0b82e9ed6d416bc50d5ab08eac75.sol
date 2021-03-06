['/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', 'pragma solidity 0.4.21;\n', '/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', '/// @title Transferable Multisignature Contract\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e387828d8a868fa38f8c8c93918a8d84cd8c9184">[email&#160;protected]</a>>.\n', 'contract TransferableMultsig {\n', '    // Note that address recovered from signatures must be strictly increasing.\n', '    function execute(\n', '        uint8[]   sigV,\n', '        bytes32[] sigR,\n', '        bytes32[] sigS,\n', '        address   destination,\n', '        uint      value,\n', '        bytes     data\n', '        )\n', '        external;\n', '    // Note that address recovered from signatures must be strictly increasing.\n', '    function transferOwnership(\n', '        uint8[]   sigV,\n', '        bytes32[] sigR,\n', '        bytes32[] sigS,\n', '        uint      _threshold,\n', '        address[] _owners\n', '        )\n', '        external;\n', '}\n', '/// @title An Implementation of TransferableMultsig???\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="7f1b1e11161a133f1310100f0d16111851100d18">[email&#160;protected]</a>>.\n', 'contract TransferableMultsigImpl is TransferableMultsig {\n', '    uint public nonce;                  // (only) mutable state\n', '    uint public threshold;              // immutable state\n', '    mapping (address => bool) ownerMap; // immutable state\n', '    address[] public owners;            // immutable state\n', '    function TransferableMultsig(\n', '        uint      _threshold,\n', '        address[] _owners\n', '        )\n', '        public\n', '    {\n', '        updateOwners(_threshold, _owners);\n', '    }\n', '    // default function does nothing.\n', '    function ()\n', '        payable\n', '        public\n', '    {\n', '    }\n', '    function execute(\n', '        uint8[]   sigV,\n', '        bytes32[] sigR,\n', '        bytes32[] sigS,\n', '        address   destination,\n', '        uint      value,\n', '        bytes     data\n', '        )\n', '        external\n', '    {\n', '        // Follows ERC191 signature scheme:\n', '        //    https://github.com/ethereum/EIPs/issues/191\n', '        bytes32 txHash = keccak256(\n', '            byte(0x19),\n', '            byte(0),\n', '            this,\n', '            nonce++,\n', '            destination,\n', '            value,\n', '            data\n', '        );\n', '        verifySignatures(\n', '            sigV,\n', '            sigR,\n', '            sigS,\n', '            txHash\n', '        );\n', '        require(\n', '            destination.call.value(value)(data)\n', '        );\n', '    }\n', '    function transferOwnership(\n', '        uint8[]   sigV,\n', '        bytes32[] sigR,\n', '        bytes32[] sigS,\n', '        uint      _threshold,\n', '        address[] _owners\n', '        )\n', '        external\n', '    {\n', '        // Follows ERC191 signature scheme:\n', '        //    https://github.com/ethereum/EIPs/issues/191\n', '        bytes32 txHash = keccak256(\n', '            byte(0x19),\n', '            byte(0),\n', '            this,\n', '            nonce++,\n', '            _threshold,\n', '            _owners\n', '        );\n', '        verifySignatures(\n', '            sigV,\n', '            sigR,\n', '            sigS,\n', '            txHash\n', '        );\n', '        updateOwners(_threshold, _owners);\n', '    }\n', '    function verifySignatures(\n', '        uint8[]   sigV,\n', '        bytes32[] sigR,\n', '        bytes32[] sigS,\n', '        bytes32   txHash\n', '        )\n', '        view\n', '        internal\n', '    {\n', '        uint _threshold = threshold;\n', '        require(_threshold == sigR.length);\n', '        require(_threshold == sigS.length);\n', '        require(_threshold == sigV.length);\n', '        address lastAddr = 0x0; // cannot have 0x0 as an owner\n', '        for (uint i = 0; i < threshold; i++) {\n', '            address recovered = ecrecover(\n', '                txHash,\n', '                sigV[i],\n', '                sigR[i],\n', '                sigS[i]\n', '            );\n', '            require(recovered > lastAddr && ownerMap[recovered]);\n', '            lastAddr = recovered;\n', '        }\n', '    }\n', '    function updateOwners(\n', '        uint      _threshold,\n', '        address[] _owners\n', '        )\n', '        internal\n', '    {\n', '        require(_owners.length <= 10);\n', '        require(_threshold <= _owners.length);\n', '        require(_threshold != 0);\n', '        // remove all current owners from ownerMap.\n', '        address[] memory currentOwners = owners;\n', '        for (uint i = 0; i < currentOwners.length; i++) {\n', '            ownerMap[currentOwners[i]] = false;\n', '        }\n', '        address lastAddr = 0x0;\n', '        for (i = 0; i < _owners.length; i++) {\n', '            address owner = _owners[i];\n', '            require(owner > lastAddr);\n', '            ownerMap[owner] = true;\n', '            lastAddr = owner;\n', '        }\n', '        owners = _owners;\n', '        threshold = _threshold;\n', '    }\n', '}']