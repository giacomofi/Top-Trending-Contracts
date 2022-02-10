['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-01\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'contract FeeSplitter {\n', '\n', '    address payable public dev1;\n', '    address payable public dev2;\n', '    address payable public dev3;\n', '    uint public shares1;\n', '    uint public shares2;\n', '    uint public shares3;\n', '\n', '    bool internal locked;\n', '\n', '    constructor(address payable _dev1, address payable _dev2, address payable _dev3, uint8 _shares1, uint8 _shares2, uint8 _shares3) {\n', '        dev1 = _dev1;\n', '        dev2 = _dev2;\n', '        dev3 = _dev3;\n', '        shares1 = _shares1;\n', '        shares2 = _shares2;\n', '        shares3 = _shares3;\n', '        require(shares1 + shares2 + shares3 == 100, "Shares must add up to 100");\n', '    }\n', '\n', '    receive() external payable noReentrant {\n', '        uint payout1 = address(this).balance * shares1 / 100;\n', '        uint payout2 = address(this).balance * shares2 / 100;\n', '        uint payout3 = address(this).balance * shares3 / 100;\n', '\n', '        (bool success1,) = dev1.call{value: payout1}("");\n', '        (bool success2,) = dev2.call{value: payout2}("");\n', '        (bool success3,) = dev3.call{value: payout3}("");\n', '\n', '        require(success1 && success2 && success3, "Sending ether failed");\n', '    }\n', '\n', '    fallback() external payable {\n', '\n', '    }\n', '\n', '    modifier noReentrant() {\n', '        require(!locked, "No reentrancy");\n', '        locked = true;\n', '        _;\n', '        locked = false;\n', '    }\n', '\n', '}']