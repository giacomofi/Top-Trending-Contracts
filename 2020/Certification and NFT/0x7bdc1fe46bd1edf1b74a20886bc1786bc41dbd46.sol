['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.5.17;\n', '\n', 'interface VaultLike {\n', '    function available() external view returns (uint);\n', '    function earn() external;\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract VaultBatchEarn is Ownable {\n', '    struct Vault {\n', '        VaultLike vault;\n', '        uint limit;\n', '    }\n', '\n', '    mapping (uint => Vault) public vaults;\n', '    mapping (address => uint) public indexes;\n', '    \n', '    uint256 public numOfVaults;\n', '    \n', '    function addVault(VaultLike v, uint lim, uint8 decimals) public onlyOwner {\n', '        require(lim > 0);\n', '        v.available(); // Quick check if vault has available()\n', '        \n', '        uint index = indexes[address(v)];\n', '        if (vaults[index].vault == v) {\n', '            vaults[index].limit = lim * (10 ** uint(decimals));\n', '        } else {\n', '            vaults[numOfVaults] = Vault(v, lim * (10 ** uint(decimals)));\n', '            indexes[address(v)] = numOfVaults;\n', '            numOfVaults++;\n', '        }\n', '    }\n', '    \n', '    function batchAddVault(VaultLike[] calldata vArray, uint[] calldata limArray, uint8[] calldata decimalsArray) external onlyOwner {\n', '        require(vArray.length == limArray.length && limArray.length == decimalsArray.length);\n', '        for (uint i = 0; i < vArray.length; i++) {\n', '            addVault(vArray[i], limArray[i], decimalsArray[i]);\n', '        }\n', '    }\n', '    \n', '    function earn() external {\n', '        for (uint i; i < numOfVaults; i++)  {\n', '            Vault memory v = vaults[i];\n', '            if (v.vault.available() > v.limit) {\n', '                  v.vault.earn();\n', '            }\n', '        }\n', '    }\n', '    \n', '    function shouldCallEarn() external view returns (bool) {\n', '        for (uint i; i < numOfVaults; i++)  {\n', '            Vault memory v = vaults[i];\n', '            if (v.vault.available() > v.limit) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '}']