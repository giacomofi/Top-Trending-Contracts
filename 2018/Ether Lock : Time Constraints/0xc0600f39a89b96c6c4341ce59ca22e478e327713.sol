['/*\n', '* ETHEREUM ACCUMULATIVE SMARTCONTRACT\n', '* Web              -            https://ethx.live\n', '* EN  Telegram_chat: https://t.me/ethx_en\n', '* RU  Telegram_chat: https://t.me/ethx_ru\n', '* CN  Telegram_chat: https://t.me/ethx_cn\n', '* \n', '*  - GAIN 4-5% OF YOUR DEPOSIT  PER 24 HOURS (every 5900 blocks)\n', '*  - 4% IF YOUR TOTAL DEPOSIT 0.01-1 ETH\n', '*  - 4.25% IF YOUR TOTAL DEPOSIT 1-10 ETH\n', '*  - 4.5% IF YOUR TOTAL DEPOSIT 10-20 ETH\n', '*  - 4.75% IF YOUR TOTAL DEPOSIT 20-40 ETH\n', '*  - 5% IF YOUR TOTAL DEPOSIT 40+ ETH\n', '*  - Life-long payments\n', '*  - The revolutionary reliability\n', '*  - Minimal contribution is 0.01 eth\n', '*  - Currency and payment - ETH\n', '*  - !!! It is not allowed to transfer from exchanges, only from your personal ETH wallet !!!\n', '*\n', '*  - Contribution allocation schemes:\n', '*    -- 90% payments\n', '*    -- 10% Marketing + Operating Expenses\n', '*\n', '* --- How to use:\n', '*  1. Send from ETH wallet to the smart contract address "0xc0600F39a89b96c6c4341cE59ca22E478E327713"\n', '*     any amount above 0.01 ETH.\n', '*  2. Verify your transaction in the history of your application or etherscan.io, specifying the address \n', '*     of your wallet.\n', '*  3a. Claim your profit by sending 0 ether transaction \n', '*  OR\n', '*  3b. For reinvest, you need first to remove the accumulated percentage of charges (by sending 0 ether \n', '*      transaction), and only after that, deposit the amount that you want to reinvest.\n', '*  \n', '* RECOMMENDED GAS LIMIT: 200000\n', '* RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', '* You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.\n', '*\n', '* \n', '* Contracts reviewed and approved by pros!\n', '*/\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract ethx {\n', '    mapping (address => uint256) invested;\n', '    mapping (address => uint256) atBlock;\n', '    uint256 minValue; \n', '    address owner1;    // 10%\n', '    event Withdraw (address indexed _to, uint256 _amount);\n', '    event Invested (address indexed _to, uint256 _amount);\n', '    \n', '    constructor () public {\n', '        owner1 = 0x0D257779Bbe6321d8349eEbCb2f0f5a90409DB80;    // 10%\n', '        minValue = 0.01 ether; //min amount for transaction\n', '    }\n', '    \n', '    /**\n', '     * This function calculated percent\n', '     * less than 1 Ether    - 4.0  %\n', '     * 1-10 Ether           - 4.25 %\n', '     * 10-20 Ether          - 4.5  %\n', '     * 20-40 Ether          - 4.75 %\n', '     * more than 40 Ether   - 5.0  %\n', '     */\n', '        function getPercent(address _investor) internal view returns (uint256) {\n', '        uint256 percent = 400;\n', '        if(invested[_investor] >= 1 ether && invested[_investor] < 10 ether) {\n', '            percent = 425;\n', '        }\n', '\n', '        if(invested[_investor] >= 10 ether && invested[_investor] < 20 ether) {\n', '            percent = 450;\n', '        }\n', '\n', '        if(invested[_investor] >= 20 ether && invested[_investor] < 40 ether) {\n', '            percent = 475;\n', '        }\n', '\n', '        if(invested[_investor] >= 40 ether) {\n', '            percent = 500;\n', '        }\n', '        \n', '        return percent;\n', '    }\n', '    \n', '    /**\n', '     * Main function\n', '     */\n', '    function () external payable {\n', '        require (msg.value == 0 || msg.value >= minValue,"Min Amount for investing is 0.01 Ether.");\n', '        \n', '        uint256 invest = msg.value;\n', '        address sender = msg.sender;\n', '        //fee owners\n', '        owner1.transfer(invest / 10);\n', '            \n', '        if (invested[sender] != 0) {\n', '            uint256 amount = invested[sender] * getPercent(sender) / 10000 * (block.number - atBlock[sender]) / 5900;\n', '\n', '            //fee sender\n', '            sender.transfer(amount);\n', '            emit Withdraw (sender, amount);\n', '        }\n', '\n', '        atBlock[sender] = block.number;\n', '        invested[sender] += invest;\n', '        if (invest > 0){\n', '            emit Invested(sender, invest);\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * This function show deposit\n', '     */\n', '    function showDeposit (address _deposit) public view returns(uint256) {\n', '        return invested[_deposit];\n', '    }\n', '\n', '    /**\n', '     * This function show block of last change\n', '     */\n', '    function showLastChange (address _deposit) public view returns(uint256) {\n', '        return atBlock[_deposit];\n', '    }\n', '\n', '    /**\n', '     * This function show unpayed percent of deposit\n', '     */\n', '    function showUnpayedPercent (address _deposit) public view returns(uint256) {\n', '        uint256 amount = invested[_deposit] * getPercent(_deposit) / 10000 * (block.number - atBlock[_deposit]) / 5900;\n', '        return amount;\n', '    }\n', '\n', '\n', '}']