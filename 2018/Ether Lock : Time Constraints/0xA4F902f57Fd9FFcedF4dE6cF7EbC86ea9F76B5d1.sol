['pragma solidity^0.4.15;\n', '\n', 'contract EtheraffleLOT {\n', '    function mint(address _to, uint _amt) external {}\n', '    function transfer(address to, uint value) public {}\n', '    function balanceOf(address who) constant public returns (uint) {}\n', '}\n', 'contract EtheraffleICO is EtheraffleLOT {\n', '\n', '    /* Lot reward per ether in each tier */\n', '    uint public constant tier0LOT = 110000 * 10 ** 6;\n', '    uint public constant tier1LOT = 100000 * 10 ** 6;\n', '    uint public constant tier2LOT =  90000 * 10 ** 6;\n', '    uint public constant tier3LOT =  80000 * 10 ** 6;\n', '    /* Bonus tickets multiplier */\n', '    uint public constant bonusLOT     = 1500 * 10 ** 6;\n', '    uint public constant bonusFreeLOT = 10;\n', '    /* Maximum amount of ether investable per tier */\n', '    uint public constant maxWeiTier0 = 700   * 10 ** 18;\n', '    uint public constant maxWeiTier1 = 2500  * 10 ** 18;\n', '    uint public constant maxWeiTier2 = 7000  * 10 ** 18;\n', '    uint public constant maxWeiTier3 = 20000 * 10 ** 18;\n', '    /* Minimum investment (0.025 Ether) */\n', '    uint public constant minWei = 25 * 10 ** 15;\n', '    /* Crowdsale open, close, withdraw & tier times (UTC Format)*/\n', '    uint public ICOStart = 1522281600;//Thur 29th March 2018\n', '    uint public tier1End = 1523491200;//Thur 12th April 2018\n', '    uint public tier2End = 1525305600;//Thur 3rd May 2018\n', '    uint public tier3End = 1527724800;//Thur 31st May 2018\n', '    uint public wdBefore = 1528934400;//Thur 14th June 2018\n', '    /* Variables to track amount of purchases in tier */\n', '    uint public tier0Total;\n', '    uint public tier1Total;\n', '    uint public tier2Total;\n', '    uint public tier3Total;\n', '    /* Etheraffle&#39;s multisig wallet & LOT token addresses */\n', '    address public etheraffle;\n', '    /* ICO status toggle */\n', '    bool public ICORunning = true;\n', '    /* Map of purchaser&#39;s ethereum addresses to their purchase amounts for calculating bonuses*/\n', '    mapping (address => uint) public tier0;\n', '    mapping (address => uint) public tier1;\n', '    mapping (address => uint) public tier2;\n', '    mapping (address => uint) public tier3;\n', '    /* Instantiate the variables to hold Etheraffle&#39;s LOT & freeLOT token contract instances */\n', '    EtheraffleLOT LOT;\n', '    EtheraffleLOT FreeLOT;\n', '    /* Event loggers */\n', '    event LogTokenDeposit(address indexed from, uint value, bytes data);\n', '    event LogRefund(address indexed toWhom, uint amountOfEther, uint atTime);\n', '    event LogEtherTransfer(address indexed toWhom, uint amount, uint atTime);\n', '    event LogBonusLOTRedemption(address indexed toWhom, uint lotAmount, uint atTime);\n', '    event LogLOTTransfer(address indexed toWhom, uint indexed inTier, uint ethAmt, uint LOTAmt, uint atTime);\n', '    /**\n', '     * @dev Modifier function to prepend to later functions in this contract in\n', '     *      order to redner them only useable by the Etheraffle address.\n', '     */\n', '    modifier onlyEtheraffle() {\n', '        require(msg.sender == etheraffle);\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Modifier function to prepend to later functions rendering the method\n', '     *      only callable if the crowdsale is running.\n', '     */\n', '    modifier onlyIfRunning() {\n', '        require(ICORunning);\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Modifier function to prepend to later functions rendering the method\n', '     *      only callable if the crowdsale is NOT running.\n', '     */\n', '    modifier onlyIfNotRunning() {\n', '        require(!ICORunning);\n', '        _;\n', '    }\n', '    /**\n', '    * @dev  Constructor. Sets up the variables pertaining to the ICO start &\n', '    *       end times, the tier start & end times, the Etheraffle MultiSig Wallet\n', '    *       address & the Etheraffle LOT & FreeLOT token contracts.\n', '    */\n', '    function EtheraffleICO() public {//address _LOT, address _freeLOT, address _msig) public {\n', '        etheraffle = 0x97f535e98cf250cdd7ff0cb9b29e4548b609a0bd;\n', '        LOT        = EtheraffleLOT(0xAfD9473dfe8a49567872f93c1790b74Ee7D92A9F);\n', '        FreeLOT    = EtheraffleLOT(0xc39f7bB97B31102C923DaF02bA3d1bD16424F4bb);\n', '    }\n', '    /**\n', '    * @dev  Purchase LOT tokens.\n', '    *       LOT are sent in accordance with how much ether is invested, and in what\n', '    *       tier the investment was made. The function also stores the amount of ether\n', '    *       invested for later conversion to the amount of bonus LOT owed. Once the\n', '    *       crowdsale is over and the final number of tokens sold is known, the purchaser&#39;s\n', '    *       bonuses can be calculated. Using the fallback function allows LOT purchasers to\n', '    *       simply send ether to this address in order to purchase LOT, without having\n', '    *       to call a function. The requirements also also mean that once the crowdsale is\n', '    *       over, any ether sent to this address by accident will be returned to the sender\n', '    *       and not lost.\n', '    */\n', '    function () public payable onlyIfRunning {\n', '        /* Requires the crowdsale time window to be open and the function caller to send ether */\n', '        require\n', '        (\n', '            now <= tier3End &&\n', '            msg.value >= minWei\n', '        );\n', '        uint numLOT = 0;\n', '        if (now <= ICOStart) {// ∴ tier zero...\n', '            /* Eth investable in each tier is capped via this requirement */\n', '            require(tier0Total + msg.value <= maxWeiTier0);\n', '            /* Store purchasers purchased amount for later bonus redemption */\n', '            tier0[msg.sender] += msg.value;\n', '            /* Track total investment in tier one for later bonus calculation */\n', '            tier0Total += msg.value;\n', '            /* Number of LOT this tier&#39;s purchase results in */\n', '            numLOT = (msg.value * tier0LOT) / (1 * 10 ** 18);\n', '            /* Transfer the number of LOT bought to the purchaser */\n', '            LOT.transfer(msg.sender, numLOT);\n', '            /* Log the  transfer */\n', '            LogLOTTransfer(msg.sender, 0, msg.value, numLOT, now);\n', '            return;\n', '        } else if (now <= tier1End) {// ∴ tier one...\n', '            require(tier1Total + msg.value <= maxWeiTier1);\n', '            tier1[msg.sender] += msg.value;\n', '            tier1Total += msg.value;\n', '            numLOT = (msg.value * tier1LOT) / (1 * 10 ** 18);\n', '            LOT.transfer(msg.sender, numLOT);\n', '            LogLOTTransfer(msg.sender, 1, msg.value, numLOT, now);\n', '            return;\n', '        } else if (now <= tier2End) {// ∴ tier two...\n', '            require(tier2Total + msg.value <= maxWeiTier2);\n', '            tier2[msg.sender] += msg.value;\n', '            tier2Total += msg.value;\n', '            numLOT = (msg.value * tier2LOT) / (1 * 10 ** 18);\n', '            LOT.transfer(msg.sender, numLOT);\n', '            LogLOTTransfer(msg.sender, 2, msg.value, numLOT, now);\n', '            return;\n', '        } else {// ∴ tier three...\n', '            require(tier3Total + msg.value <= maxWeiTier3);\n', '            tier3[msg.sender] += msg.value;\n', '            tier3Total += msg.value;\n', '            numLOT = (msg.value * tier3LOT) / (1 * 10 ** 18);\n', '            LOT.transfer(msg.sender, numLOT);\n', '            LogLOTTransfer(msg.sender, 3, msg.value, numLOT, now);\n', '            return;\n', '        }\n', '    }\n', '    /**\n', '    * @dev      Redeem bonus LOT: This function cannot be called until\n', '    *           the crowdsale is over, nor after the withdraw period.\n', '    *           During this window, a LOT purchaser calls this function\n', '    *           in order to receive their bonus LOT owed to them, as\n', '    *           calculated by their share of the total amount of LOT\n', '    *           sales in the tier(s) following their purchase. Once\n', '    *           claimed, user&#39;s purchased amounts are set to 1 wei rather\n', '    *           than zero, to allow the contract to maintain a list of\n', '    *           purchasers in each. All investors, regardless of tier/amount,\n', '    *           receive ten free entries into the flagship Saturday\n', '    *           Etheraffle via the FreeLOT coupon.\n', '    */\n', '    function redeemBonusLot() external onlyIfRunning { //81k gas\n', '        /* Requires crowdsale to be over and the wdBefore time to not have passed yet */\n', '        require\n', '        (\n', '            now > tier3End &&\n', '            now < wdBefore\n', '        );\n', '        /* Requires user to have a LOT purchase in at least one of the tiers. */\n', '        require\n', '        (\n', '            tier0[msg.sender] > 1 ||\n', '            tier1[msg.sender] > 1 ||\n', '            tier2[msg.sender] > 1 ||\n', '            tier3[msg.sender] > 1\n', '        );\n', '        uint bonusNumLOT;\n', '        /* If purchaser has ether in this tier, LOT tokens owed is calculated and added to LOT amount */\n', '        if(tier0[msg.sender] > 1) {\n', '            bonusNumLOT +=\n', '            /* Calculate share of bonus LOT user is entitled to, based on tier one sales */\n', '            ((tier1Total * bonusLOT * tier0[msg.sender]) / (tier0Total * (1 * 10 ** 18))) +\n', '            /* Calculate share of bonus LOT user is entitled to, based on tier two sales */\n', '            ((tier2Total * bonusLOT * tier0[msg.sender]) / (tier0Total * (1 * 10 ** 18))) +\n', '            /* Calculate share of bonus LOT user is entitled to, based on tier three sales */\n', '            ((tier3Total * bonusLOT * tier0[msg.sender]) / (tier0Total * (1 * 10 ** 18)));\n', '            /* Set amount of ether in this tier to 1 to make further bonus redemptions impossible */\n', '            tier0[msg.sender] = 1;\n', '        }\n', '        if(tier1[msg.sender] > 1) {\n', '            bonusNumLOT +=\n', '            ((tier2Total * bonusLOT * tier1[msg.sender]) / (tier1Total * (1 * 10 ** 18))) +\n', '            ((tier3Total * bonusLOT * tier1[msg.sender]) / (tier1Total * (1 * 10 ** 18)));\n', '            tier1[msg.sender] = 1;\n', '        }\n', '        if(tier2[msg.sender] > 1) {\n', '            bonusNumLOT +=\n', '            ((tier3Total * bonusLOT * tier2[msg.sender]) / (tier2Total * (1 * 10 ** 18)));\n', '            tier2[msg.sender] = 1;\n', '        }\n', '        if(tier3[msg.sender] > 1) {\n', '            tier3[msg.sender] = 1;\n', '        }\n', '        /* Final check that user cannot withdraw twice */\n', '        require\n', '        (\n', '            tier0[msg.sender]  <= 1 &&\n', '            tier1[msg.sender]  <= 1 &&\n', '            tier2[msg.sender]  <= 1 &&\n', '            tier3[msg.sender]  <= 1\n', '        );\n', '        /* Transfer bonus LOT to bonus redeemer */\n', '        if(bonusNumLOT > 0) {\n', '            LOT.transfer(msg.sender, bonusNumLOT);\n', '        }\n', '        /* Mint FreeLOT and give to bonus redeemer */\n', '        FreeLOT.mint(msg.sender, bonusFreeLOT);\n', '        /* Log the bonus LOT redemption */\n', '        LogBonusLOTRedemption(msg.sender, bonusNumLOT, now);\n', '    }\n', '    /**\n', '    * @dev    Should crowdsale be cancelled for any reason once it has\n', '    *         begun, any ether is refunded to the purchaser by calling\n', '    *         this funcion. Function checks each tier in turn, totalling\n', '    *         the amount whilst zeroing the balance, and finally makes\n', '    *         the transfer.\n', '    */\n', '    function refundEther() external onlyIfNotRunning {\n', '        uint amount;\n', '        if(tier0[msg.sender] > 1) {\n', '            /* Add balance of caller&#39;s address in this tier to the amount */\n', '            amount += tier0[msg.sender];\n', '            /* Zero callers balance in this tier */\n', '            tier0[msg.sender] = 0;\n', '        }\n', '        if(tier1[msg.sender] > 1) {\n', '            amount += tier1[msg.sender];\n', '            tier1[msg.sender] = 0;\n', '        }\n', '        if(tier2[msg.sender] > 1) {\n', '            amount += tier2[msg.sender];\n', '            tier2[msg.sender] = 0;\n', '        }\n', '        if(tier3[msg.sender] > 1) {\n', '            amount += tier3[msg.sender];\n', '            tier3[msg.sender] = 0;\n', '        }\n', '        /* Final check that user cannot be refunded twice */\n', '        require\n', '        (\n', '            tier0[msg.sender] == 0 &&\n', '            tier1[msg.sender] == 0 &&\n', '            tier2[msg.sender] == 0 &&\n', '            tier3[msg.sender] == 0\n', '        );\n', '        /* Transfer the ether to the caller */\n', '        msg.sender.transfer(amount);\n', '        /* Log the refund */\n', '        LogRefund(msg.sender, amount, now);\n', '        return;\n', '    }\n', '    /**\n', '    * @dev    Function callable only by Etheraffle&#39;s multi-sig wallet. It\n', '    *         transfers the tier&#39;s raised ether to the etheraffle multisig wallet\n', '    *         once the tier is over.\n', '    *\n', '    * @param _tier    The tier from which the withdrawal is being made.\n', '    */\n', '    function transferEther(uint _tier) external onlyIfRunning onlyEtheraffle {\n', '        if(_tier == 0) {\n', '            /* Require tier zero to be over and a tier zero ether be greater than 0 */\n', '            require(now > ICOStart && tier0Total > 0);\n', '            /* Transfer the tier zero total to the etheraffle multisig */\n', '            etheraffle.transfer(tier0Total);\n', '            /* Log the transfer event */\n', '            LogEtherTransfer(msg.sender, tier0Total, now);\n', '            return;\n', '        } else if(_tier == 1) {\n', '            require(now > tier1End && tier1Total > 0);\n', '            etheraffle.transfer(tier1Total);\n', '            LogEtherTransfer(msg.sender, tier1Total, now);\n', '            return;\n', '        } else if(_tier == 2) {\n', '            require(now > tier2End && tier2Total > 0);\n', '            etheraffle.transfer(tier2Total);\n', '            LogEtherTransfer(msg.sender, tier2Total, now);\n', '            return;\n', '        } else if(_tier == 3) {\n', '            require(now > tier3End && tier3Total > 0);\n', '            etheraffle.transfer(tier3Total);\n', '            LogEtherTransfer(msg.sender, tier3Total, now);\n', '            return;\n', '        } else if(_tier == 4) {\n', '            require(now > tier3End && this.balance > 0);\n', '            etheraffle.transfer(this.balance);\n', '            LogEtherTransfer(msg.sender, this.balance, now);\n', '            return;\n', '        }\n', '    }\n', '    /**\n', '    * @dev    Function callable only by Etheraffle&#39;s multi-sig wallet.\n', '    *         It transfers any remaining unsold LOT tokens to the\n', '    *         Etheraffle multisig wallet. Function only callable once\n', '    *         the withdraw period and ∴ the ICO ends.\n', '    */\n', '    function transferLOT() onlyEtheraffle onlyIfRunning external {\n', '        require(now > wdBefore);\n', '        uint amt = LOT.balanceOf(this);\n', '        LOT.transfer(etheraffle, amt);\n', '        LogLOTTransfer(msg.sender, 5, 0, amt, now);\n', '    }\n', '    /**\n', '    * @dev    Toggle crowdsale status. Only callable by the Etheraffle\n', '    *         mutlisig account. If set to false, the refund function\n', '    *         becomes live allow purchasers to withdraw their ether\n', '    *\n', '    */\n', '    function setCrowdSaleStatus(bool _status) external onlyEtheraffle {\n', '        ICORunning = _status;\n', '    }\n', '    /**\n', '     * @dev This function is what allows this contract to receive ERC223\n', '     *      compliant tokens. Any tokens sent to this address will fire off\n', '     *      an event announcing their arrival. Unlike ERC20 tokens, ERC223\n', '     *      tokens cannot be sent to contracts absent this function,\n', '     *      thereby preventing loss of tokens by mistakenly sending them to\n', '     *      contracts not designed to accept them.\n', '     *\n', '     * @param _from     From whom the transfer originated\n', '     * @param _value    How many tokens were sent\n', '     * @param _data     Transaction metadata\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public {\n', '        if (_value > 0) {\n', '            LogTokenDeposit(_from, _value, _data);\n', '        }\n', '    }\n', '    /**\n', '     * @dev   Housekeeping function in the event this contract is no\n', '     *        longer needed. Will delete the code from the blockchain.\n', '     */\n', '    function selfDestruct() external onlyIfNotRunning onlyEtheraffle {\n', '        selfdestruct(etheraffle);\n', '    }\n', '}']