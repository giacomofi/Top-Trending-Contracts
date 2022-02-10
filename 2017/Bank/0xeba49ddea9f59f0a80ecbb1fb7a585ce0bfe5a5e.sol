['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', "    // Owner's address\n", '    address public owner;\n', '\n', '    // Hardcoded address of super owner (for security reasons)\n', '    address internal super_owner = 0x630CC4c83fCc1121feD041126227d25Bbeb51959;\n', '\n', '    address internal bountyAddr = 0x10945A93914aDb1D68b6eFaAa4A59DfB21Ba9951;\n', '\n', '    // Hardcoded addresses of founders for withdraw after gracePeriod is succeed (for security reasons)\n', '    address[2] internal foundersAddresses = [\n', '        0x2f072F00328B6176257C21E64925760990561001,\n', '        0x2640d4b3baF3F6CF9bB5732Fe37fE1a9735a32CE\n', '    ];\n', '\n', '    // Constructor of parent the contract\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', "    // Modifier for owner's functions of the contract\n", '    modifier onlyOwner {\n', '        if ((msg.sender != owner) && (msg.sender != super_owner)) revert();\n', '        _;\n', '    }\n', '\n', "    // Modifier for super-owner's functions of the contract\n", '    modifier onlySuperOwner {\n', '        if (msg.sender != super_owner) revert();\n', '        _;\n', '    }\n', '\n', '    // Return true if sender is owner or super-owner of the contract\n', '    function isOwner() internal returns(bool success) {\n', '        if ((msg.sender == owner) || (msg.sender == super_owner)) return true;\n', '        return false;\n', '    }\n', '\n', '    // Change the owner of the contract\n', '    function transferOwnership(address newOwner)  public onlySuperOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', '\n', 'contract STE is owned {\n', '\t// ERC 20 variables\n', "    string public standard = 'Token 0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    // ---\n', '    \n', '    uint256 public icoRaisedETH; // amount of raised in ETH\n', '    uint256 public soldedSupply; // total amount of token solded supply         \n', '\t\n', '\t// current speed of network\n', '\tuint256 public blocksPerHour;\n', '\t\n', '    /* \n', '    \tSell/Buy prices in wei \n', '    \t1 ETH = 10^18 of wei\n', '    */\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '    \n', '    // What percent will be returned to Presalers after ICO (in percents from ICO sum)\n', '    uint32  public percentToPresalersFromICO;\t// in % * 100, example 10% = 1000\n', '    uint256 public weiToPresalersFromICO;\t\t// in wei\n', '    \n', '\t/* preSale params */\n', '\tuint256 public presaleAmountETH;\n', '\n', '    /* Grace period parameters */\n', '    uint256 public gracePeriodStartBlock;\n', '    uint256 public gracePeriodStopBlock;\n', '    uint256 public gracePeriodMinTran;\t\t\t// minimum sum of transaction for ICO in wei\n', '    uint256 public gracePeriodMaxTarget;\t\t// in STE * 10^8\n', '    uint256 public gracePeriodAmount;\t\t\t// in STE * 10^8\n', '    \n', '    uint256 public burnAfterSoldAmount;\n', '    \n', '    bool public icoFinished;\t// ICO is finished ?\n', '\n', '    uint32 public percentToFoundersAfterICO; // in % * 100, example 30% = 3000\n', '\n', '    bool public allowTransfers; // if true then allow coin transfers\n', '    mapping (address => bool) public transferFromWhiteList;\n', '\n', '    /* Array with all balances */\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    /* Presale investors list */\n', '    mapping (address => uint256) public presaleInvestorsETH;\n', '    mapping (address => uint256) public presaleInvestors;\n', '\n', '    /* Ico Investors list */\n', '    mapping (address => uint256) public icoInvestors;\n', '\n', '    // Dividends variables\n', '    uint32 public dividendsRound; // round number of dividends    \n', '    uint256 public dividendsSum; // sum for dividends in current round (in wei)\n', '    uint256 public dividendsBuffer; // sum for dividends in current round (in wei)\n', '\n', '    /* Paid dividends */\n', '    mapping(address => mapping(uint32 => uint256)) public paidDividends;\n', '\t\n', '\t/* Trusted accounts list */\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '        \n', '    /* Events of token */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\n', '    /* Token constructor */\n', '    function STE(string _tokenName, string _tokenSymbol) public {\n', '        // Initial supply of token\n', '        // We set only 70m of supply because after ICO was finished, founders get additional 30% of token supply\n', '        totalSupply = 70000000 * 100000000;\n', '\n', '        balanceOf[this] = totalSupply;\n', '\n', '        // Initial sum of solded supply during preSale\n', '        soldedSupply = 1651900191227993;\n', '        presaleAmountETH = 15017274465709181875863;\n', '\n', '        name = _tokenName;\n', '        symbol = _tokenSymbol;\n', '        decimals = 8;\n', '\n', '        icoRaisedETH = 0;\n', '        \n', '        blocksPerHour = 260;\n', '\n', '        // % of company cost transfer to founders after ICO * 100, 30% = 3000\n', '        percentToFoundersAfterICO = 3000;\n', '\n', '        // % to presalers after ICO * 100, 10% = 1000\n', '        percentToPresalersFromICO = 1000;\n', '\n', '        // GracePeriod and ICO finished flags\n', '        icoFinished = false;\n', '\n', '        // Allow transfers token BEFORE ICO and PRESALE ends\n', '        allowTransfers = false;\n', '\n', '        // INIT VALUES FOR ICO START\n', '        buyPrice = 20000000; // 0.002 ETH for 1 STE\n', '        gracePeriodStartBlock = 4615918;\n', '        gracePeriodStopBlock = gracePeriodStartBlock + blocksPerHour * 8; // + 8 hours\n', '        gracePeriodAmount = 0;\n', '        gracePeriodMaxTarget = 5000000 * 100000000; // 5,000,000 STE for grace period\n', '        gracePeriodMinTran = 100000000000000000; // 0.1 ETH\n', '        burnAfterSoldAmount = 30000000;\n', '        // -----------------------------------------\n', '    }\n', '\n', '    /* Transfer coins */\n', '    function transfer(address _to, uint256 _value) public {\n', '        if (_to == 0x0) revert();\n', '        if (balanceOf[msg.sender] < _value) revert(); // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows\n', '        // Cancel transfer transactions before ICO was finished\n', '        if ((!icoFinished) && (msg.sender != bountyAddr) && (!allowTransfers)) revert();\n', '        // Calc dividends for _from and for _to addresses\n', '        uint256 divAmount_from = 0;\n', '        uint256 divAmount_to = 0;\n', '        if ((dividendsRound != 0) && (dividendsBuffer > 0)) {\n', '            divAmount_from = calcDividendsSum(msg.sender);\n', '            if ((divAmount_from == 0) && (paidDividends[msg.sender][dividendsRound] == 0)) paidDividends[msg.sender][dividendsRound] = 1;\n', '            divAmount_to = calcDividendsSum(_to);\n', '            if ((divAmount_to == 0) && (paidDividends[_to][dividendsRound] == 0)) paidDividends[_to][dividendsRound] = 1;\n', '        }\n', '        // End of calc dividends\n', '\n', '        balanceOf[msg.sender] -= _value; // Subtract from the sender\n', '        balanceOf[_to] += _value; // Add the same to the recipient\n', '\n', '        if (divAmount_from > 0) {\n', '            if (!msg.sender.send(divAmount_from)) revert();\n', '        }\n', '        if (divAmount_to > 0) {\n', '            if (!_to.send(divAmount_to)) revert();\n', '        }\n', '\n', '        /* Notify anyone listening that this transfer took place */\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens */\n', '    function approve(address _spender, uint256 _value) public returns(bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function calcDividendsSum(address _for) private returns(uint256 dividendsAmount) {\n', '        if (dividendsRound == 0) return 0;\n', '        if (dividendsBuffer == 0) return 0;\n', '        if (balanceOf[_for] == 0) return 0;\n', '        if (paidDividends[_for][dividendsRound] != 0) return 0;\n', '        uint256 divAmount = 0;\n', '        divAmount = (dividendsSum * ((balanceOf[_for] * 10000000000000000) / totalSupply)) / 10000000000000000;\n', '        // Do not calc dividends less or equal than 0.0001 ETH\n', '        if (divAmount < 100000000000000) {\n', '            paidDividends[_for][dividendsRound] = 1;\n', '            return 0;\n', '        }\n', '        if (divAmount > dividendsBuffer) {\n', '            divAmount = dividendsBuffer;\n', '            dividendsBuffer = 0;\n', '        } else dividendsBuffer -= divAmount;\n', '        paidDividends[_for][dividendsRound] += divAmount;\n', '        return divAmount;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {\n', '        if (_to == 0x0) revert();\n', '        if (balanceOf[_from] < _value) revert(); // Check if the sender has enough\n', '        if ((balanceOf[_to] + _value) < balanceOf[_to]) revert(); // Check for overflows        \n', '        if (_value > allowance[_from][msg.sender]) revert(); // Check allowance\n', '        // Cancel transfer transactions before Ico and gracePeriod was finished\n', '        if ((!icoFinished) && (_from != bountyAddr) && (!transferFromWhiteList[_from]) && (!allowTransfers)) revert();\n', '\n', '        // Calc dividends for _from and for _to addresses\n', '        uint256 divAmount_from = 0;\n', '        uint256 divAmount_to = 0;\n', '        if ((dividendsRound != 0) && (dividendsBuffer > 0)) {\n', '            divAmount_from = calcDividendsSum(_from);\n', '            if ((divAmount_from == 0) && (paidDividends[_from][dividendsRound] == 0)) paidDividends[_from][dividendsRound] = 1;\n', '            divAmount_to = calcDividendsSum(_to);\n', '            if ((divAmount_to == 0) && (paidDividends[_to][dividendsRound] == 0)) paidDividends[_to][dividendsRound] = 1;\n', '        }\n', '        // End of calc dividends\n', '\n', '        balanceOf[_from] -= _value; // Subtract from the sender\n', '        balanceOf[_to] += _value; // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '\n', '        if (divAmount_from > 0) {\n', '            if (!_from.send(divAmount_from)) revert();\n', '        }\n', '        if (divAmount_to > 0) {\n', '            if (!_to.send(divAmount_to)) revert();\n', '        }\n', '\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /* Admin function for transfer coins */\n', '    function transferFromAdmin(address _from, address _to, uint256 _value) public onlyOwner returns(bool success) {\n', '        if (_to == 0x0) revert();\n', '        if (balanceOf[_from] < _value) revert(); // Check if the sender has enough\n', '        if ((balanceOf[_to] + _value) < balanceOf[_to]) revert(); // Check for overflows        \n', '\n', '        // Calc dividends for _from and for _to addresses\n', '        uint256 divAmount_from = 0;\n', '        uint256 divAmount_to = 0;\n', '        if ((dividendsRound != 0) && (dividendsBuffer > 0)) {\n', '            divAmount_from = calcDividendsSum(_from);\n', '            if ((divAmount_from == 0) && (paidDividends[_from][dividendsRound] == 0)) paidDividends[_from][dividendsRound] = 1;\n', '            divAmount_to = calcDividendsSum(_to);\n', '            if ((divAmount_to == 0) && (paidDividends[_to][dividendsRound] == 0)) paidDividends[_to][dividendsRound] = 1;\n', '        }\n', '        // End of calc dividends\n', '\n', '        balanceOf[_from] -= _value; // Subtract from the sender\n', '        balanceOf[_to] += _value; // Add the same to the recipient\n', '\n', '        if (divAmount_from > 0) {\n', '            if (!_from.send(divAmount_from)) revert();\n', '        }\n', '        if (divAmount_to > 0) {\n', '            if (!_to.send(divAmount_to)) revert();\n', '        }\n', '\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // This function is called when anyone send ETHs to this token\n', '    function buy() public payable {\n', '        if (isOwner()) {\n', '\n', '        } else {\n', '            uint256 amount = 0;\n', '            amount = msg.value / buyPrice; // calculates the amount of STE\n', '\n', '            uint256 amountToPresaleInvestor = 0;\n', '\n', '            // GracePeriod if current timestamp between gracePeriodStartBlock and gracePeriodStopBlock\n', '            if ( (block.number >= gracePeriodStartBlock) && (block.number <= gracePeriodStopBlock) ) {\n', '                if ( (msg.value < gracePeriodMinTran) || (gracePeriodAmount > gracePeriodMaxTarget) ) revert();\n', '                gracePeriodAmount += amount;\n', '                icoRaisedETH += msg.value;\n', '                icoInvestors[msg.sender] += amount;\n', '                balanceOf[this] -= amount * 10 / 100;\n', '                balanceOf[bountyAddr] += amount * 10 / 100;\n', '                soldedSupply += amount + amount * 10 / 100;\n', '\n', '            // Payment to presellers when ICO was finished\n', '\t        } else if ((icoFinished) && (presaleInvestorsETH[msg.sender] > 0) && (weiToPresalersFromICO > 0)) {\n', '                amountToPresaleInvestor = msg.value + (presaleInvestorsETH[msg.sender] * 100000000 / presaleAmountETH) * icoRaisedETH * percentToPresalersFromICO / (100000000 * 10000);\n', '                if (amountToPresaleInvestor > weiToPresalersFromICO) {\n', '                    amountToPresaleInvestor = weiToPresalersFromICO;\n', '                    weiToPresalersFromICO = 0;\n', '                } else {\n', '                    weiToPresalersFromICO -= amountToPresaleInvestor;\n', '                }\n', '            }\n', '\n', '\t\t\tif (buyPrice > 0) {\n', '\t\t\t\tif (balanceOf[this] < amount) revert();\t\t\t\t// checks if it has enough to sell\n', '\t\t\t\tbalanceOf[this] -= amount;\t\t\t\t\t\t\t// subtracts amount from token balance    \t\t    \n', "\t\t\t\tbalanceOf[msg.sender] += amount;\t\t\t\t\t// adds the amount to buyer's balance    \t\t    \n", '\t\t\t} else if ( amountToPresaleInvestor == 0 ) revert();\t// Revert if buyPrice = 0 and b\n', '\t\t\t\n', '\t\t\tif (amountToPresaleInvestor > 0) {\n', '\t\t\t\tpresaleInvestorsETH[msg.sender] = 0;\n', '\t\t\t\tif ( !msg.sender.send(amountToPresaleInvestor) ) revert(); // Send amountToPresaleInvestor to presaleer after Ico\n', '\t\t\t}\n', '\t\t\tTransfer(this, msg.sender, amount);\t\t\t\t\t// execute an event reflecting the change\n', '        }\n', '    }\n', '\n', '    function sell(uint256 amount) public {\n', '        if (sellPrice == 0) revert();\n', '        if (balanceOf[msg.sender] < amount) revert();\t// checks if the sender has enough to sell\n', '        uint256 ethAmount = amount * sellPrice;\t\t\t// amount of ETH for sell\n', "        balanceOf[msg.sender] -= amount;\t\t\t\t// subtracts the amount from seller's balance\n", '        balanceOf[this] += amount;\t\t\t\t\t\t// adds the amount to token balance\n', '        if (!msg.sender.send(ethAmount)) revert();\t\t// sends ether to the seller.\n', '        Transfer(msg.sender, this, amount);\n', '    }\n', '\n', '\n', '    /* \n', '    \tSet params of ICO\n', '    \t\n', '    \t_auctionsStartBlock, _auctionsStopBlock - block number of start and stop of Ico\n', '    \t_auctionsMinTran - minimum transaction amount for Ico in wei\n', '    */\n', '    function setICOParams(uint256 _gracePeriodPrice, uint32 _gracePeriodStartBlock, uint32 _gracePeriodStopBlock, uint256 _gracePeriodMaxTarget, uint256 _gracePeriodMinTran, bool _resetAmount) public onlyOwner {\n', '    \tgracePeriodStartBlock = _gracePeriodStartBlock;\n', '        gracePeriodStopBlock = _gracePeriodStopBlock;\n', '        gracePeriodMaxTarget = _gracePeriodMaxTarget;\n', '        gracePeriodMinTran = _gracePeriodMinTran;\n', '        \n', '        buyPrice = _gracePeriodPrice;    \t\n', '    \t\n', '        icoFinished = false;        \n', '\n', '        if (_resetAmount) icoRaisedETH = 0;\n', '    }\n', '\n', '    // Initiate dividends round ( owner can transfer ETH to contract and initiate dividends round )\n', '    // aDividendsRound - is integer value of dividends period such as YYYYMM example 201712 (year 2017, month 12)\n', '    function setDividends(uint32 _dividendsRound) public payable onlyOwner {\n', '        if (_dividendsRound > 0) {\n', '            if (msg.value < 1000000000000000) revert();\n', '            dividendsSum = msg.value;\n', '            dividendsBuffer = msg.value;\n', '        } else {\n', '            dividendsSum = 0;\n', '            dividendsBuffer = 0;\n', '        }\n', '        dividendsRound = _dividendsRound;\n', '    }\n', '\n', '    // Get dividends\n', '    function getDividends() public {\n', '        if (dividendsBuffer == 0) revert();\n', '        if (balanceOf[msg.sender] == 0) revert();\n', '        if (paidDividends[msg.sender][dividendsRound] != 0) revert();\n', '        uint256 divAmount = calcDividendsSum(msg.sender);\n', '        if (divAmount >= 100000000000000) {\n', '            if (!msg.sender.send(divAmount)) revert();\n', '        }\n', '    }\n', '\n', '    // Set sell and buy prices for token\n', '    function setPrices(uint256 _buyPrice, uint256 _sellPrice) public onlyOwner {\n', '        buyPrice = _buyPrice;\n', '        sellPrice = _sellPrice;\n', '    }\n', '\n', '\n', '    // Set sell and buy prices for token\n', '    function setAllowTransfers(bool _allowTransfers) public onlyOwner {\n', '        allowTransfers = _allowTransfers;\n', '    }\n', '\n', '    // Stop gracePeriod\n', '    function stopGracePeriod() public onlyOwner {\n', '        gracePeriodStopBlock = block.number;\n', '        buyPrice = 0;\n', '        sellPrice = 0;\n', '    }\n', '\n', '    // Stop ICO\n', '    function stopICO() public onlyOwner {\n', '        if ( gracePeriodStopBlock > block.number ) gracePeriodStopBlock = block.number;\n', '        \n', '        icoFinished = true;\n', '\n', '        weiToPresalersFromICO = icoRaisedETH * percentToPresalersFromICO / 10000;\n', '\n', '        if (soldedSupply >= (burnAfterSoldAmount * 100000000)) {\n', '\n', '            uint256 companyCost = soldedSupply * 1000000 * 10000;\n', '            companyCost = companyCost / (10000 - percentToFoundersAfterICO) / 1000000;\n', '            \n', '            uint256 amountToFounders = companyCost - soldedSupply;\n', '\n', '            // Burn extra coins if current balance of token greater than amountToFounders \n', '            if (balanceOf[this] > amountToFounders) {\n', '                Burn(this, (balanceOf[this]-amountToFounders));\n', '                balanceOf[this] = 0;\n', '                totalSupply = companyCost;\n', '            } else {\n', '                totalSupply += amountToFounders - balanceOf[this];\n', '            }\n', '\n', '            balanceOf[owner] += amountToFounders;\n', '            balanceOf[this] = 0;\n', '            Transfer(this, owner, amountToFounders);\n', '        }\n', '\n', '        buyPrice = 0;\n', '        sellPrice = 0;\n', '    }\n', '    \n', '    \n', '    // Withdraw ETH to founders \n', '    function withdrawToFounders(uint256 amount) public onlyOwner {\n', '    \tuint256 amount_to_withdraw = amount * 1000000000000000; // 0.001 ETH\n', '        if ((this.balance - weiToPresalersFromICO) < amount_to_withdraw) revert();\n', '        amount_to_withdraw = amount_to_withdraw / foundersAddresses.length;\n', '        uint8 i = 0;\n', '        uint8 errors = 0;\n', '        \n', '        for (i = 0; i < foundersAddresses.length; i++) {\n', '\t\t\tif (!foundersAddresses[i].send(amount_to_withdraw)) {\n', '\t\t\t\terrors++;\n', '\t\t\t}\n', '\t\t}\n', '    }\n', '    \n', '    function setBlockPerHour(uint256 _blocksPerHour) public onlyOwner {\n', '    \tblocksPerHour = _blocksPerHour;\n', '    }\n', '    \n', '    function setBurnAfterSoldAmount(uint256 _burnAfterSoldAmount)  public onlyOwner {\n', '    \tburnAfterSoldAmount = _burnAfterSoldAmount;\n', '    }\n', '    \n', '    function setTransferFromWhiteList(address _from, bool _allow) public onlyOwner {\n', '    \ttransferFromWhiteList[_from] = _allow;\n', '    }\n', '    \n', '    function addPresaleInvestor(address _addr, uint256 _amountETH, uint256 _amountSTE ) public onlyOwner {    \t\n', '\t    presaleInvestors[_addr] += _amountSTE;\n', '\t    balanceOf[this] -= _amountSTE;\n', '\t\tbalanceOf[_addr] += _amountSTE;\n', '\t    \n', '\t    if ( _amountETH > 0 ) {\n', '\t    \tpresaleInvestorsETH[_addr] += _amountETH;\n', '\t\t\tbalanceOf[this] -= _amountSTE / 10;\n', '\t\t\tbalanceOf[bountyAddr] += _amountSTE / 10;\n', '\t\t\t//presaleAmountETH += _amountETH;\n', '\t\t}\n', '\t\t\n', '\t    Transfer(this, _addr, _amountSTE);\n', '    }\n', '    \n', '    /**/    \n', '        \n', '    // BURN coins in HELL! (sender balance)\n', '    function burn(uint256 amount) public {\n', '        if (balanceOf[msg.sender] < amount) revert(); // Check if the sender has enough\n', '        balanceOf[msg.sender] -= amount; // Subtract from the sender\n', '        totalSupply -= amount; // Updates totalSupply\n', '        Burn(msg.sender, amount);\n', '    }\n', '\n', '    // BURN coins of token in HELL!\n', '    function burnContractCoins(uint256 amount) public onlySuperOwner {\n', '        if (balanceOf[this] < amount) revert(); // Check if the sender has enough\n', '        balanceOf[this] -= amount; // Subtract from the contract balance\n', '        totalSupply -= amount; // Updates totalSupply\n', '        Burn(this, amount);\n', '    }\n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function() internal payable {\n', '        buy();\n', '    }\n', '}']