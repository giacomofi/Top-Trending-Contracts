['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-03\n', '*/\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * \n', ' * World War Goo - Competitive Idle Game\n', ' * \n', ' */\n', '\n', 'contract GooBurnAlgo {\n', '    \n', '    Bankroll constant bankroll = Bankroll(0x66a9f1e53173de33bec727ef76afa84956ae1b25);\n', '    GooToken constant goo = GooToken(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);\n', '    \n', '    // Updated naive algorithm, splitting eth equally between totalSupply\n', '    function priceOf(uint256 amount) external view returns(uint256 payment) {\n', '        payment = (bankroll.gooPurchaseAllocation() * amount) / goo.totalSupply();\n', '    }\n', '    \n', '    function price() external view returns(uint256 gooPrice) {\n', '        gooPrice = bankroll.gooPurchaseAllocation() / goo.totalSupply();\n', '    }\n', '    \n', '}\n', '\n', '\n', 'contract Bankroll {\n', "    uint256 public gooPurchaseAllocation; // Wei destined to pay to burn players' goo\n", '}\n', '\n', 'contract GooToken {\n', '    function totalSupply() external view returns(uint256);\n', '}']