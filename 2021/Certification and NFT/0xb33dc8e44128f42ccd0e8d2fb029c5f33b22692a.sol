['pragma solidity ^0.6.0;\n', "import './CrowdSaleBase.sol';\n", "import './SafeMath.sol';\n", '// SPDX-License-Identifier: UNLICENSED\n', '\n', 'contract CrowdSale is CrowdSaleBase {\n', '    using SafeMath for uint256;\n', '    \n', '    constructor() public {\n', '        wallet = 0xA4A5564Fbb72a0C0026082C5E6863AE21FB79E31;\n', '        // This is the Fundrasing address \n', '        \n', '        token = IERC20(0x1E19D4e538B1583613347671965A2FA848271f8a);\n', '        // This is the address of the smart contract of token on ethscan.\n', '      \n', '        \n', '        startDate = 1623715331;\n', '        // start date of ICO in EPOCH time stamp - Use https://www.epochconverter.com/ for getting the timestamps\n', '        \n', '        endDate = 1640953855;\n', '        // end date of ICO in EPOCH time stamp - Use https://www.epochconverter.com/ for getting the timestamps\n', '        \n', '        minimumParticipationAmount = 20000000000000000 wei;\n', '        // Example value here is 0.02 eth. This is the minimum amount of eth a contributor will have to put in.\n', '        \n', '        minimumToRaise = 1000000000000000 wei;\n', '        // 0.001 eth.\n', '        // This the minimum amount to be raised for the ICO to marked as valid or complete. You can also put this as 0 or 1 wei.\n', '        \n', '        chainLinkAddress = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;\n', '     \n', '        // Chainlink Address to get live rate of Eth\n', '        \n', '        \n', '        cap = 16467100000000000000000 wei;\n', '        // The amount you have to raise after which the ICO will close\n', '        //16467.10 Eth \n', '    }\n', '}']