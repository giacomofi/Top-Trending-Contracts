['pragma solidity ^0.4.18;\n', '\n', '// Created by LLC "Uinkey" <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e587808497868d8c8ea58288848c89cb868a88">[email&#160;protected]</a>\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface ManagedToken{\n', '    function setLock(bool _newLockState) public returns (bool success);\n', '    function mint(address _for, uint256 _amount) public returns (bool success);\n', '    function demint(address _for, uint256 _amount) public returns (bool success);\n', '    function decimals() view public returns (uint8 decDigits);\n', '    function totalSupply() view public returns (uint256 supply);\n', '    function balanceOf(address _owner) view public returns (uint256 balance);\n', '}\n', '  \n', 'contract HardcodedCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    //global definisions\n', '\n', '    enum ICOStateEnum {NotStarted, Started, Refunded, Successful}\n', '\n', '    address public owner = msg.sender;\n', '    ManagedToken public managedTokenLedger;\n', '\n', '    string public name = "Coinplace";\n', '    string public symbol = "CPL";\n', '\n', '    bool public halted = false;\n', '     \n', '    uint256 public minTokensToBuy = 100;\n', '    \n', '    uint256 public ICOcontributors = 0;\n', '\n', '    uint256 public ICOstart = 1521518400; //20 Mar 2018 13:00:00 GMT+9\n', '    uint256 public ICOend = 1526857200; // 20 May 2018 13:00:00 GMT+9\n', '    uint256 public Hardcap = 20000 ether; \n', '    uint256 public ICOcollected = 0;\n', '    uint256 public Softcap = 200 ether;\n', '    uint256 public ICOtokensSold = 0;\n', '    uint256 public TakedFunds = 0;\n', '    ICOStateEnum public ICOstate = ICOStateEnum.NotStarted;\n', '    \n', '    uint8 public decimals = 9;\n', '    uint256 public DECIMAL_MULTIPLIER = 10**uint256(decimals);\n', ' \n', '    uint256 public ICOprice = uint256(1 ether).div(1000);\n', '    uint256[4] public ICOamountBonusLimits = [5 ether, 20 ether, 50 ether, 200 ether];\n', '    uint256[4] public ICOamountBonusMultipierInPercent = [103, 105, 107, 110]; // count bonus\n', '    uint256[5] public ICOweekBonus = [130, 125, 120, 115, 110]; // time bonus\n', '\n', '    mapping(address => uint256) public weiForRefundICO;\n', '\n', '    mapping(address => uint256) public weiToRecoverICO;\n', '\n', '    mapping(address => uint256) public balancesForICO;\n', '\n', '    event Purchased(address indexed _from, uint256 _value);\n', '\n', '    function advanceState() public returns (bool success) {\n', '        transitionState();\n', '        return true;\n', '    }\n', '\n', '    function transitionState() internal {\n', '        if (now >= ICOstart) {\n', '            if (ICOstate == ICOStateEnum.NotStarted) {\n', '                ICOstate = ICOStateEnum.Started;\n', '            }\n', '            if (Hardcap > 0 && ICOcollected >= Hardcap) {\n', '                ICOstate = ICOStateEnum.Successful;\n', '            }\n', '        } if (now >= ICOend) {\n', '            if (ICOstate == ICOStateEnum.Started) {\n', '                if (ICOcollected >= Softcap) {\n', '                    ICOstate = ICOStateEnum.Successful;\n', '                } else {\n', '                    ICOstate = ICOStateEnum.Refunded;\n', '                }\n', '            }\n', '        } \n', '    }\n', '\n', '    modifier stateTransition() {\n', '        transitionState();\n', '        _;\n', '        transitionState();\n', '    }\n', '\n', '    modifier notHalted() {\n', '        require(!halted);\n', '        _;\n', '    }\n', '\n', '    // Ownership\n', '\n', '    event OwnershipTransferred(address indexed viousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));      \n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return managedTokenLedger.balanceOf(_owner);\n', '    }\n', '\n', '    function totalSupply() view public returns (uint256 balance) {\n', '        return managedTokenLedger.totalSupply();\n', '    }\n', '\n', '\n', '    function HardcodedCrowdsale (address _newLedgerAddress) public {\n', '        require(_newLedgerAddress != address(0));\n', '        managedTokenLedger = ManagedToken(_newLedgerAddress);\n', '        assert(managedTokenLedger.decimals() == decimals);\n', '    }\n', '\n', '    function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {\n', '        require(bytes(_name).length > 1);\n', '        require(bytes(_symbol).length > 1);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        return true;\n', '    }\n', '\n', '    function setLedger (address _newLedgerAddress) onlyOwner public returns (bool success) {\n', '        require(_newLedgerAddress != address(0));\n', '        managedTokenLedger = ManagedToken(_newLedgerAddress);\n', '        assert(managedTokenLedger.decimals() == decimals);\n', '        return true;\n', '    }\n', '\n', '    function () payable stateTransition notHalted external {\n', '        require(msg.value > 0);\n', '        require(ICOstate == ICOStateEnum.Started);\n', '        assert(ICOBuy());\n', '    }\n', '\n', '    \n', '    function finalize() stateTransition public returns (bool success) {\n', '        require(ICOstate == ICOStateEnum.Successful);\n', '        owner.transfer(ICOcollected - TakedFunds);\n', '        return true;\n', '    }\n', '\n', '    function setHalt(bool _halt) onlyOwner public returns (bool success) {\n', '        halted = _halt;\n', '        return true;\n', '    }\n', '\n', '    function calculateAmountBoughtICO(uint256 _weisSentScaled, uint256 _amountBonusMultiplier) \n', '        internal returns (uint256 _tokensToBuyScaled, uint256 _weisLeftScaled) {\n', '        uint256 value = _weisSentScaled;\n', '        uint256 totalPurchased = 0;\n', '        \n', '        totalPurchased = value.div(ICOprice);\n', '\t    uint256 weekbonus = getWeekBonus(totalPurchased).sub(totalPurchased);\n', '\t    uint256 forThisRate = totalPurchased.mul(_amountBonusMultiplier).div(100).sub(totalPurchased);\n', '\t    value = _weisSentScaled.sub(totalPurchased.mul(ICOprice));\n', '        totalPurchased = totalPurchased.add(forThisRate).add(weekbonus);\n', '        \n', '        \n', '        return (totalPurchased, value);\n', '    }\n', '\n', '    function getBonusMultipierInPercents(uint256 _sentAmount) public view returns (uint256 _multi) {\n', '        uint256 bonusMultiplier = 100;\n', '        for (uint8 i = 0; i < ICOamountBonusLimits.length; i++) {\n', '            if (_sentAmount < ICOamountBonusLimits[i]) {\n', '                break;\n', '            } else {\n', '                bonusMultiplier = ICOamountBonusMultipierInPercent[i];\n', '            }\n', '        }\n', '        return bonusMultiplier;\n', '    }\n', '    \n', '    function getWeekBonus(uint256 amountTokens) internal view returns(uint256 count) {\n', '        uint256 countCoints = 0;\n', '        uint256 bonusMultiplier = 100;\n', '        if(block.timestamp <= (ICOstart + 1 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[0] );\n', '        } else if (block.timestamp <= (ICOstart + 2 weeks) && block.timestamp <= (ICOstart + 3 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[1] );\n', '        } else if (block.timestamp <= (ICOstart + 4 weeks) && block.timestamp <= (ICOstart + 5 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[2] );\n', '        } else if (block.timestamp <= (ICOstart + 6 weeks) && block.timestamp <= (ICOstart + 7 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[3] );\n', '        } else {\n', '            countCoints = amountTokens.mul(ICOweekBonus[4] );\n', '        }\n', '        return countCoints.div(bonusMultiplier);\n', '    }\n', '\n', '    function ICOBuy() internal notHalted returns (bool success) {\n', '        uint256 weisSentScaled = msg.value.mul(DECIMAL_MULTIPLIER);\n', '        address _for = msg.sender;\n', '        uint256 amountBonus = getBonusMultipierInPercents(msg.value);\n', '        var (tokensBought, fundsLeftScaled) = calculateAmountBoughtICO(weisSentScaled, amountBonus);\n', '        if (tokensBought < minTokensToBuy.mul(DECIMAL_MULTIPLIER)) {\n', '            revert();\n', '        }\n', '        uint256 fundsLeft = fundsLeftScaled.div(DECIMAL_MULTIPLIER);\n', '        uint256 totalSpent = msg.value.sub(fundsLeft);\n', '        if (balanceOf(_for) == 0) {\n', '            ICOcontributors = ICOcontributors + 1;\n', '        }\n', '        managedTokenLedger.mint(_for, tokensBought);\n', '        balancesForICO[_for] = balancesForICO[_for].add(tokensBought);\n', '        weiForRefundICO[_for] = weiForRefundICO[_for].add(totalSpent);\n', '        weiToRecoverICO[_for] = weiToRecoverICO[_for].add(fundsLeft);\n', '        Purchased(_for, tokensBought);\n', '        ICOcollected = ICOcollected.add(totalSpent);\n', '        ICOtokensSold = ICOtokensSold.add(tokensBought);\n', '        return true;\n', '    }\n', '\n', '    function recoverLeftoversICO() stateTransition notHalted public returns (bool success) {\n', '        require(ICOstate != ICOStateEnum.NotStarted);\n', '        uint256 value = weiToRecoverICO[msg.sender];\n', '        delete weiToRecoverICO[msg.sender];\n', '        msg.sender.transfer(value);\n', '        return true;\n', '    }\n', '\n', '    function refundICO() stateTransition notHalted public returns (bool success) {\n', '        require(ICOstate == ICOStateEnum.Refunded);\n', '        uint256 value = weiForRefundICO[msg.sender];\n', '        delete weiForRefundICO[msg.sender];\n', '        uint256 tokenValue = balancesForICO[msg.sender];\n', '        delete balancesForICO[msg.sender];\n', '        managedTokenLedger.demint(msg.sender, tokenValue);\n', '        msg.sender.transfer(value);\n', '        return true;\n', '    }\n', '    \n', '    function withdrawFunds() onlyOwner public returns (bool success) {\n', '        require(Softcap <= ICOcollected);\n', '        owner.transfer(ICOcollected - TakedFunds);\n', '        TakedFunds = ICOcollected;\n', '        return true;\n', '    }\n', '    \n', '    function manualSendTokens(address rAddress, uint256 amount) onlyOwner public returns (bool success) {\n', '        managedTokenLedger.mint(rAddress, amount);\n', '        balancesForICO[rAddress] = balancesForICO[rAddress].add(amount);\n', '        Purchased(rAddress, amount);\n', '        ICOtokensSold = ICOtokensSold.add(amount);\n', '        return true;\n', '    } \n', '\n', '    function cleanup() onlyOwner public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// Created by LLC "Uinkey" bearchik@gmail.com\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface ManagedToken{\n', '    function setLock(bool _newLockState) public returns (bool success);\n', '    function mint(address _for, uint256 _amount) public returns (bool success);\n', '    function demint(address _for, uint256 _amount) public returns (bool success);\n', '    function decimals() view public returns (uint8 decDigits);\n', '    function totalSupply() view public returns (uint256 supply);\n', '    function balanceOf(address _owner) view public returns (uint256 balance);\n', '}\n', '  \n', 'contract HardcodedCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    //global definisions\n', '\n', '    enum ICOStateEnum {NotStarted, Started, Refunded, Successful}\n', '\n', '    address public owner = msg.sender;\n', '    ManagedToken public managedTokenLedger;\n', '\n', '    string public name = "Coinplace";\n', '    string public symbol = "CPL";\n', '\n', '    bool public halted = false;\n', '     \n', '    uint256 public minTokensToBuy = 100;\n', '    \n', '    uint256 public ICOcontributors = 0;\n', '\n', '    uint256 public ICOstart = 1521518400; //20 Mar 2018 13:00:00 GMT+9\n', '    uint256 public ICOend = 1526857200; // 20 May 2018 13:00:00 GMT+9\n', '    uint256 public Hardcap = 20000 ether; \n', '    uint256 public ICOcollected = 0;\n', '    uint256 public Softcap = 200 ether;\n', '    uint256 public ICOtokensSold = 0;\n', '    uint256 public TakedFunds = 0;\n', '    ICOStateEnum public ICOstate = ICOStateEnum.NotStarted;\n', '    \n', '    uint8 public decimals = 9;\n', '    uint256 public DECIMAL_MULTIPLIER = 10**uint256(decimals);\n', ' \n', '    uint256 public ICOprice = uint256(1 ether).div(1000);\n', '    uint256[4] public ICOamountBonusLimits = [5 ether, 20 ether, 50 ether, 200 ether];\n', '    uint256[4] public ICOamountBonusMultipierInPercent = [103, 105, 107, 110]; // count bonus\n', '    uint256[5] public ICOweekBonus = [130, 125, 120, 115, 110]; // time bonus\n', '\n', '    mapping(address => uint256) public weiForRefundICO;\n', '\n', '    mapping(address => uint256) public weiToRecoverICO;\n', '\n', '    mapping(address => uint256) public balancesForICO;\n', '\n', '    event Purchased(address indexed _from, uint256 _value);\n', '\n', '    function advanceState() public returns (bool success) {\n', '        transitionState();\n', '        return true;\n', '    }\n', '\n', '    function transitionState() internal {\n', '        if (now >= ICOstart) {\n', '            if (ICOstate == ICOStateEnum.NotStarted) {\n', '                ICOstate = ICOStateEnum.Started;\n', '            }\n', '            if (Hardcap > 0 && ICOcollected >= Hardcap) {\n', '                ICOstate = ICOStateEnum.Successful;\n', '            }\n', '        } if (now >= ICOend) {\n', '            if (ICOstate == ICOStateEnum.Started) {\n', '                if (ICOcollected >= Softcap) {\n', '                    ICOstate = ICOStateEnum.Successful;\n', '                } else {\n', '                    ICOstate = ICOStateEnum.Refunded;\n', '                }\n', '            }\n', '        } \n', '    }\n', '\n', '    modifier stateTransition() {\n', '        transitionState();\n', '        _;\n', '        transitionState();\n', '    }\n', '\n', '    modifier notHalted() {\n', '        require(!halted);\n', '        _;\n', '    }\n', '\n', '    // Ownership\n', '\n', '    event OwnershipTransferred(address indexed viousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));      \n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return managedTokenLedger.balanceOf(_owner);\n', '    }\n', '\n', '    function totalSupply() view public returns (uint256 balance) {\n', '        return managedTokenLedger.totalSupply();\n', '    }\n', '\n', '\n', '    function HardcodedCrowdsale (address _newLedgerAddress) public {\n', '        require(_newLedgerAddress != address(0));\n', '        managedTokenLedger = ManagedToken(_newLedgerAddress);\n', '        assert(managedTokenLedger.decimals() == decimals);\n', '    }\n', '\n', '    function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {\n', '        require(bytes(_name).length > 1);\n', '        require(bytes(_symbol).length > 1);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        return true;\n', '    }\n', '\n', '    function setLedger (address _newLedgerAddress) onlyOwner public returns (bool success) {\n', '        require(_newLedgerAddress != address(0));\n', '        managedTokenLedger = ManagedToken(_newLedgerAddress);\n', '        assert(managedTokenLedger.decimals() == decimals);\n', '        return true;\n', '    }\n', '\n', '    function () payable stateTransition notHalted external {\n', '        require(msg.value > 0);\n', '        require(ICOstate == ICOStateEnum.Started);\n', '        assert(ICOBuy());\n', '    }\n', '\n', '    \n', '    function finalize() stateTransition public returns (bool success) {\n', '        require(ICOstate == ICOStateEnum.Successful);\n', '        owner.transfer(ICOcollected - TakedFunds);\n', '        return true;\n', '    }\n', '\n', '    function setHalt(bool _halt) onlyOwner public returns (bool success) {\n', '        halted = _halt;\n', '        return true;\n', '    }\n', '\n', '    function calculateAmountBoughtICO(uint256 _weisSentScaled, uint256 _amountBonusMultiplier) \n', '        internal returns (uint256 _tokensToBuyScaled, uint256 _weisLeftScaled) {\n', '        uint256 value = _weisSentScaled;\n', '        uint256 totalPurchased = 0;\n', '        \n', '        totalPurchased = value.div(ICOprice);\n', '\t    uint256 weekbonus = getWeekBonus(totalPurchased).sub(totalPurchased);\n', '\t    uint256 forThisRate = totalPurchased.mul(_amountBonusMultiplier).div(100).sub(totalPurchased);\n', '\t    value = _weisSentScaled.sub(totalPurchased.mul(ICOprice));\n', '        totalPurchased = totalPurchased.add(forThisRate).add(weekbonus);\n', '        \n', '        \n', '        return (totalPurchased, value);\n', '    }\n', '\n', '    function getBonusMultipierInPercents(uint256 _sentAmount) public view returns (uint256 _multi) {\n', '        uint256 bonusMultiplier = 100;\n', '        for (uint8 i = 0; i < ICOamountBonusLimits.length; i++) {\n', '            if (_sentAmount < ICOamountBonusLimits[i]) {\n', '                break;\n', '            } else {\n', '                bonusMultiplier = ICOamountBonusMultipierInPercent[i];\n', '            }\n', '        }\n', '        return bonusMultiplier;\n', '    }\n', '    \n', '    function getWeekBonus(uint256 amountTokens) internal view returns(uint256 count) {\n', '        uint256 countCoints = 0;\n', '        uint256 bonusMultiplier = 100;\n', '        if(block.timestamp <= (ICOstart + 1 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[0] );\n', '        } else if (block.timestamp <= (ICOstart + 2 weeks) && block.timestamp <= (ICOstart + 3 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[1] );\n', '        } else if (block.timestamp <= (ICOstart + 4 weeks) && block.timestamp <= (ICOstart + 5 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[2] );\n', '        } else if (block.timestamp <= (ICOstart + 6 weeks) && block.timestamp <= (ICOstart + 7 weeks)) {\n', '            countCoints = amountTokens.mul(ICOweekBonus[3] );\n', '        } else {\n', '            countCoints = amountTokens.mul(ICOweekBonus[4] );\n', '        }\n', '        return countCoints.div(bonusMultiplier);\n', '    }\n', '\n', '    function ICOBuy() internal notHalted returns (bool success) {\n', '        uint256 weisSentScaled = msg.value.mul(DECIMAL_MULTIPLIER);\n', '        address _for = msg.sender;\n', '        uint256 amountBonus = getBonusMultipierInPercents(msg.value);\n', '        var (tokensBought, fundsLeftScaled) = calculateAmountBoughtICO(weisSentScaled, amountBonus);\n', '        if (tokensBought < minTokensToBuy.mul(DECIMAL_MULTIPLIER)) {\n', '            revert();\n', '        }\n', '        uint256 fundsLeft = fundsLeftScaled.div(DECIMAL_MULTIPLIER);\n', '        uint256 totalSpent = msg.value.sub(fundsLeft);\n', '        if (balanceOf(_for) == 0) {\n', '            ICOcontributors = ICOcontributors + 1;\n', '        }\n', '        managedTokenLedger.mint(_for, tokensBought);\n', '        balancesForICO[_for] = balancesForICO[_for].add(tokensBought);\n', '        weiForRefundICO[_for] = weiForRefundICO[_for].add(totalSpent);\n', '        weiToRecoverICO[_for] = weiToRecoverICO[_for].add(fundsLeft);\n', '        Purchased(_for, tokensBought);\n', '        ICOcollected = ICOcollected.add(totalSpent);\n', '        ICOtokensSold = ICOtokensSold.add(tokensBought);\n', '        return true;\n', '    }\n', '\n', '    function recoverLeftoversICO() stateTransition notHalted public returns (bool success) {\n', '        require(ICOstate != ICOStateEnum.NotStarted);\n', '        uint256 value = weiToRecoverICO[msg.sender];\n', '        delete weiToRecoverICO[msg.sender];\n', '        msg.sender.transfer(value);\n', '        return true;\n', '    }\n', '\n', '    function refundICO() stateTransition notHalted public returns (bool success) {\n', '        require(ICOstate == ICOStateEnum.Refunded);\n', '        uint256 value = weiForRefundICO[msg.sender];\n', '        delete weiForRefundICO[msg.sender];\n', '        uint256 tokenValue = balancesForICO[msg.sender];\n', '        delete balancesForICO[msg.sender];\n', '        managedTokenLedger.demint(msg.sender, tokenValue);\n', '        msg.sender.transfer(value);\n', '        return true;\n', '    }\n', '    \n', '    function withdrawFunds() onlyOwner public returns (bool success) {\n', '        require(Softcap <= ICOcollected);\n', '        owner.transfer(ICOcollected - TakedFunds);\n', '        TakedFunds = ICOcollected;\n', '        return true;\n', '    }\n', '    \n', '    function manualSendTokens(address rAddress, uint256 amount) onlyOwner public returns (bool success) {\n', '        managedTokenLedger.mint(rAddress, amount);\n', '        balancesForICO[rAddress] = balancesForICO[rAddress].add(amount);\n', '        Purchased(rAddress, amount);\n', '        ICOtokensSold = ICOtokensSold.add(amount);\n', '        return true;\n', '    } \n', '\n', '    function cleanup() onlyOwner public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '}']
