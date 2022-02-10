['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-24\n', '*/\n', '\n', '/*\n', '\n', '* Pynthetix: ReadProxy.sol\n', '*\n', '* Latest source (may be newer): https://github.com/Pynthetixio/pynthetix/blob/master/contracts/ReadProxy.sol\n', '* Docs: https://docs.pynthetix.io/contracts/ReadProxy\n', '*\n', '* Contract Dependencies: \n', '*\t- Owned\n', '* Libraries: (none)\n', '*\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2021 Pynthetix\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', '\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '\n', '// https://docs.pynthetix.io/contracts/source/contracts/owned\n', 'contract Owned {\n', '    address public owner;\n', '    address public nominatedOwner;\n', '\n', '    constructor(address _owner) public {\n', '        require(_owner != address(0), "Owner address cannot be 0");\n', '        owner = _owner;\n', '        emit OwnerChanged(address(0), _owner);\n', '    }\n', '\n', '    function nominateNewOwner(address _owner) external onlyOwner {\n', '        nominatedOwner = _owner;\n', '        emit OwnerNominated(_owner);\n', '    }\n', '\n', '    function acceptOwnership() external {\n', '        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");\n', '        emit OwnerChanged(owner, nominatedOwner);\n', '        owner = nominatedOwner;\n', '        nominatedOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        _onlyOwner();\n', '        _;\n', '    }\n', '\n', '    function _onlyOwner() private view {\n', '        require(msg.sender == owner, "Only the contract owner may perform this action");\n', '    }\n', '\n', '    event OwnerNominated(address newOwner);\n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '}\n', '\n', '\n', '// solhint-disable payable-fallback\n', '\n', '// https://docs.pynthetix.io/contracts/source/contracts/readproxy\n', 'contract ReadProxy is Owned {\n', '    address public target;\n', '\n', '    constructor(address _owner) public Owned(_owner) {}\n', '\n', '    function setTarget(address _target) external onlyOwner {\n', '        target = _target;\n', '        emit TargetUpdated(target);\n', '    }\n', '\n', '    function() external {\n', '        // The basics of a proxy read call\n', '        // Note that msg.sender in the underlying will always be the address of this contract.\n', '        assembly {\n', '            calldatacopy(0, 0, calldatasize)\n', '\n', '            // Use of staticcall - this will revert if the underlying function mutates state\n', '            let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)\n', '            returndatacopy(0, 0, returndatasize)\n', '\n', '            if iszero(result) {\n', '                revert(0, returndatasize)\n', '            }\n', '            return(0, returndatasize)\n', '        }\n', '    }\n', '\n', '    event TargetUpdated(address newTarget);\n', '}']