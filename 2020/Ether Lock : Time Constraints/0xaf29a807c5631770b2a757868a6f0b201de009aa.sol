['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', 'library AddrArrayLib {\n', '    using AddrArrayLib for Addresses;\n', '\n', '    struct Addresses {\n', '      address[]  _items;\n', '    }\n', '    function pushAddress(Addresses storage self, address element) internal {\n', '      if (!exists(self, element)) {\n', '        self._items.push(element);\n', '      }\n', '    }\n', '    function removeAddress(Addresses storage self, address element) internal returns (bool) {\n', '        for (uint i = 0; i < self.size(); i++) {\n', '            if (self._items[i] == element) {\n', '                self._items[i] = self._items[self.size() - 1];\n', '                self._items.pop();\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '    function getAddressAtIndex(Addresses storage self, uint256 index) internal view returns (address) {\n', '        require(index < size(self), "the index is out of bounds");\n', '        return self._items[index];\n', '    }\n', '    function size(Addresses storage self) internal view returns (uint256) {\n', '      return self._items.length;\n', '    }\n', '    function exists(Addresses storage self, address element) internal view returns (bool) {\n', '        for (uint i = 0; i < self.size(); i++) {\n', '            if (self._items[i] == element) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '    function getAllAddresses(Addresses storage self) internal view returns(address[] memory) {\n', '        return self._items;\n', '    }\n', '}\n', '\n', 'interface Minter {\n', '    // Mint new tokens\n', '    function mint(address to, uint256 amount) external returns (bool);\n', '    function changeOwner(address to) external;\n', '    function changeMinter(address to) external;\n', '}\n', '\n', 'contract Manager {\n', '    using AddrArrayLib for AddrArrayLib.Addresses;\n', '    AddrArrayLib.Addresses managers;\n', '    \n', '    event addManager(address manager);\n', '    event delManager(address manager);\n', '\n', '    constructor (address owner) public {\n', '        managers.pushAddress(owner);\n', '        emit addManager(owner);\n', '    }\n', '\n', '    modifier ownerOnly() {\n', '        require(managers.exists(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function createManager(address manager) public ownerOnly {\n', '        managers.pushAddress(manager);\n', '        emit addManager(manager);\n', '    }\n', '\n', '    function rmManager(address manager) public ownerOnly {\n', '        managers.removeAddress(manager);\n', '        emit delManager(manager);\n', '    }\n', '\n', '    function mint(address token, address to, uint256 amount) public ownerOnly returns(bool) {\n', '        Minter(token).mint(to, amount);\n', '        return true;\n', '    }\n', '\n', '    function migrate(address token, address to, bool minter) public ownerOnly {\n', '        if (minter) {\n', '            Minter(token).changeMinter(to);\n', '        } else {\n', '            Minter(token).changeOwner(to);\n', '        }\n', '    }\n', '\n', '    function listManagers() public view returns(address[] memory) {\n', '        return managers.getAllAddresses();\n', '    }\n', '}']