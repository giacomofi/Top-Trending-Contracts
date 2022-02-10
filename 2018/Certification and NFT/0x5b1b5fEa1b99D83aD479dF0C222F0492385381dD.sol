['/*\n', '-----------------------------------------------------------------\n', 'FILE HEADER\n', '-----------------------------------------------------------------\n', '\n', 'file:       TokenState.sol\n', 'version:    1.0\n', 'author:     Dominic Romanowski\n', '            Anton Jurisevic\n', '\n', 'date:       2018-2-24\n', 'checked:    Anton Jurisevic\n', 'approved:   Samuel Brooks\n', '\n', 'repo:       https://github.com/Havven/havven\n', 'commit:     34e66009b98aa18976226c139270970d105045e3\n', '\n', '-----------------------------------------------------------------\n', 'CONTRACT DESCRIPTION\n', '-----------------------------------------------------------------\n', '\n', 'An Owned contract, to be inherited by other contracts.\n', 'Requires its owner to be explicitly set in the constructor.\n', 'Provides an onlyOwner access modifier.\n', '\n', 'To change owner, the current owner must nominate the next owner,\n', 'who then has to accept the nomination. The nomination can be\n', 'cancelled before it is accepted by the new owner by having the\n', 'previous owner change the nomination (setting it to 0).\n', '-----------------------------------------------------------------\n', '*/\n', '\n', 'pragma solidity ^0.4.20;\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public nominatedOwner;\n', '\n', '    function Owned(address _owner)\n', '        public\n', '    {\n', '        owner = _owner;\n', '    }\n', '\n', '    function nominateOwner(address _owner)\n', '        external\n', '        onlyOwner\n', '    {\n', '        nominatedOwner = _owner;\n', '        emit OwnerNominated(_owner);\n', '    }\n', '\n', '    function acceptOwnership()\n', '        external\n', '    {\n', '        require(msg.sender == nominatedOwner);\n', '        emit OwnerChanged(owner, nominatedOwner);\n', '        owner = nominatedOwner;\n', '        nominatedOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event OwnerNominated(address newOwner);\n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '}\n', '\n', '/*\n', '-----------------------------------------------------------------\n', 'CONTRACT DESCRIPTION\n', '-----------------------------------------------------------------\n', '\n', 'A contract that holds the state of an ERC20 compliant token.\n', '\n', 'This contract is used side by side with external state token\n', 'contracts, such as Havven and EtherNomin.\n', 'It provides an easy way to upgrade contract logic while\n', 'maintaining all user balances and allowances. This is designed\n', 'to to make the changeover as easy as possible, since mappings\n', 'are not so cheap or straightforward to migrate.\n', '\n', 'The first deployed contract would create this state contract,\n', 'using it as its store of balances.\n', 'When a new contract is deployed, it links to the existing\n', 'state contract, whose owner would then change its associated\n', 'contract to the new one.\n', '\n', '-----------------------------------------------------------------\n', '*/\n', '\n', 'contract TokenState is Owned {\n', '\n', '    // the address of the contract that can modify balances and allowances\n', '    // this can only be changed by the owner of this contract\n', '    address public associatedContract;\n', '\n', '    // ERC20 fields.\n', '    mapping(address => uint) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    function TokenState(address _owner, address _associatedContract)\n', '        Owned(_owner)\n', '        public\n', '    {\n', '        associatedContract = _associatedContract;\n', '        emit AssociatedContractUpdated(_associatedContract);\n', '    }\n', '\n', '    /* ========== SETTERS ========== */\n', '\n', '    // Change the associated contract to a new address\n', '    function setAssociatedContract(address _associatedContract)\n', '        external\n', '        onlyOwner\n', '    {\n', '        associatedContract = _associatedContract;\n', '        emit AssociatedContractUpdated(_associatedContract);\n', '    }\n', '\n', '    function setAllowance(address tokenOwner, address spender, uint value)\n', '        external\n', '        onlyAssociatedContract\n', '    {\n', '        allowance[tokenOwner][spender] = value;\n', '    }\n', '\n', '    function setBalanceOf(address account, uint value)\n', '        external\n', '        onlyAssociatedContract\n', '    {\n', '        balanceOf[account] = value;\n', '    }\n', '\n', '\n', '    /* ========== MODIFIERS ========== */\n', '\n', '    modifier onlyAssociatedContract\n', '    {\n', '        require(msg.sender == associatedContract);\n', '        _;\n', '    }\n', '\n', '    /* ========== EVENTS ========== */\n', '\n', '    event AssociatedContractUpdated(address _associatedContract);\n', '}\n', '\n', '/*\n', 'MIT License\n', '\n', 'Copyright (c) 2018 Havven\n', '\n', 'Permission is hereby granted, free of charge, to any person obtaining a copy\n', 'of this software and associated documentation files (the "Software"), to deal\n', 'in the Software without restriction, including without limitation the rights\n', 'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', 'copies of the Software, and to permit persons to whom the Software is\n', 'furnished to do so, subject to the following conditions:\n', '\n', 'The above copyright notice and this permission notice shall be included in all\n', 'copies or substantial portions of the Software.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', 'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', 'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', 'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', 'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', 'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', 'SOFTWARE.\n', '*/']