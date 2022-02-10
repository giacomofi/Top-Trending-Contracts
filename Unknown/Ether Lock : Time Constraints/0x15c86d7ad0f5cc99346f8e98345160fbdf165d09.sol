['pragma solidity ^0.4.10;\n', '\n', 'contract Token {\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (uint256 => address) public addresses;\n', '    mapping (address => bool) public addressExists;\n', '    mapping (address => uint256) public addressIndex;\n', '    uint256 public numberOfAddress = 0;\n', '    \n', '    string public physicalString;\n', '    string public cryptoString;\n', '    \n', '    bool public isSecured;\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    bool public canMintBurn;\n', '    uint256 public txnTax;\n', '    uint256 public holdingTax;\n', '    //In Weeks, on Fridays\n', '    uint256 public holdingTaxInterval;\n', '    uint256 public lastHoldingTax;\n', '    uint256 public holdingTaxDecimals = 2;\n', '    bool public isPrivate;\n', '    \n', '    address public owner;\n', '    \n', '    function Token(string n, string a, uint256 totalSupplyToUse, bool isSecured, bool cMB, string physical, string crypto, uint256 txnTaxToUse, uint256 holdingTaxToUse, uint256 holdingTaxIntervalToUse, bool isPrivateToUse) {\n', '        name = n;\n', '        symbol = a;\n', '        totalSupply = totalSupplyToUse;\n', '        balanceOf[msg.sender] = totalSupplyToUse;\n', '        isSecured = isSecured;\n', '        physicalString = physical;\n', '        cryptoString = crypto;\n', '        canMintBurn = cMB;\n', '        owner = msg.sender;\n', '        txnTax = txnTaxToUse;\n', '        holdingTax = holdingTaxToUse;\n', '        holdingTaxInterval = holdingTaxIntervalToUse;\n', '        if(holdingTaxInterval!=0) {\n', '            lastHoldingTax = now;\n', '            while(getHour(lastHoldingTax)!=21) {\n', '                lastHoldingTax -= 1 hours;\n', '            }\n', '            while(getWeekday(lastHoldingTax)!=5) {\n', '                lastHoldingTax -= 1 days;\n', '            }\n', '            lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);\n', '        }\n', '        isPrivate = isPrivateToUse;\n', '        \n', '        addAddress(owner);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) payable {\n', '        chargeHoldingTax();\n', '        if (balanceOf[msg.sender] < _value) throw;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        if (msg.sender != owner && _to != owner && txnTax != 0) {\n', '            if(!owner.send(txnTax)) {\n', '                throw;\n', '            }\n', '        }\n', '        if(isPrivate && msg.sender != owner && !addressExists[_to]) {\n', '            throw;\n', '        }\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        addAddress(_to);\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    function changeTxnTax(uint256 _newValue) {\n', '        if(msg.sender != owner) throw;\n', '        txnTax = _newValue;\n', '    }\n', '    \n', '    function mint(uint256 _value) {\n', '        if(canMintBurn && msg.sender == owner) {\n', '            if (balanceOf[msg.sender] + _value < balanceOf[msg.sender]) throw;\n', '            balanceOf[msg.sender] += _value;\n', '            totalSupply += _value;\n', '            Transfer(0, msg.sender, _value);\n', '        }\n', '    }\n', '    \n', '    function burn(uint256 _value) {\n', '        if(canMintBurn && msg.sender == owner) {\n', '            if (balanceOf[msg.sender] < _value) throw;\n', '            balanceOf[msg.sender] -= _value;\n', '            totalSupply -= _value;\n', '            Transfer(msg.sender, 0, _value);\n', '        }\n', '    }\n', '    \n', '    function chargeHoldingTax() {\n', '        if(holdingTaxInterval!=0) {\n', '            uint256 dateDif = now - lastHoldingTax;\n', '            bool changed = false;\n', '            while(dateDif >= holdingTaxInterval * (1 weeks)) {\n', '                changed=true;\n', '                dateDif -= holdingTaxInterval * (1 weeks);\n', '                for(uint256 i = 0;i<numberOfAddress;i++) {\n', '                    if(addresses[i]!=owner) {\n', '                        uint256 amtOfTaxToPay = ((balanceOf[addresses[i]]) * holdingTax)  / (10**holdingTaxDecimals)/ (10**holdingTaxDecimals);\n', '                        balanceOf[addresses[i]] -= amtOfTaxToPay;\n', '                        balanceOf[owner] += amtOfTaxToPay;\n', '                    }\n', '                }\n', '            }\n', '            if(changed) {\n', '                lastHoldingTax = now;\n', '                while(getHour(lastHoldingTax)!=21) {\n', '                    lastHoldingTax -= 1 hours;\n', '                }\n', '                while(getWeekday(lastHoldingTax)!=5) {\n', '                    lastHoldingTax -= 1 days;\n', '                }\n', '                lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function changeHoldingTax(uint256 _newValue) {\n', '        if(msg.sender != owner) throw;\n', '        holdingTax = _newValue;\n', '    }\n', '    \n', '    function changeHoldingTaxInterval(uint256 _newValue) {\n', '        if(msg.sender != owner) throw;\n', '        holdingTaxInterval = _newValue;\n', '    }\n', '    \n', '    function addAddress (address addr) private {\n', '        if(!addressExists[addr]) {\n', '            addressIndex[addr] = numberOfAddress;\n', '            addresses[numberOfAddress++] = addr;\n', '            addressExists[addr] = true;\n', '        }\n', '    }\n', '    \n', '    function addAddressManual (address addr) {\n', '        if(msg.sender == owner && isPrivate) {\n', '            addAddress(addr);\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function removeAddress (address addr) private {\n', '        if(addressExists[addr]) {\n', '            numberOfAddress--;\n', '            addresses[addressIndex[addr]] = 0x0;\n', '            addressExists[addr] = false;\n', '        }\n', '    }\n', '    \n', '    function removeAddressManual (address addr) {\n', '        if(msg.sender == owner && isPrivate) {\n', '            removeAddress(addr);\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function getWeekday(uint timestamp) returns (uint8) {\n', '            return uint8((timestamp / 86400 + 4) % 7);\n', '    }\n', '    \n', '    function getHour(uint timestamp) returns (uint8) {\n', '            return uint8((timestamp / 60 / 60) % 24);\n', '    }\n', '\n', '    function getMinute(uint timestamp) returns (uint8) {\n', '            return uint8((timestamp / 60) % 60);\n', '    }\n', '\n', '    function getSecond(uint timestamp) returns (uint8) {\n', '            return uint8(timestamp % 60);\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', 'contract tokensale {\n', '    \n', '    Token public token;\n', '    uint256 public totalSupply;\n', '    uint256 public numberOfTokens;\n', '    uint256 public numberOfTokensLeft;\n', '    uint256 public pricePerToken;\n', '    uint256 public tokensFromPresale = 0;\n', '    uint256 public tokensFromPreviousTokensale = 0;\n', '    uint8 public decimals = 2;\n', '    uint256 public withdrawLimit = 200000000000000000000;\n', '    \n', '    address public owner;\n', '    string public name;\n', '    string public symbol;\n', '    \n', '    address public finalAddress = 0x5904957d25D0c6213491882a64765967F88BCCC7;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => bool) public addressExists;\n', '    mapping (uint256 => address) public addresses;\n', '    mapping (address => uint256) public addressIndex;\n', '    uint256 public numberOfAddress = 0;\n', '    \n', '    mapping (uint256 => uint256) public dates;\n', '    mapping (uint256 => uint256) public percents;\n', '    uint256 public numberOfDates = 8;\n', '    \n', '    tokensale ps = tokensale(0xa67d97d75eE175e05BB1FB17529FD772eE8E9030);\n', '    tokensale pts = tokensale(0xED6c0654cD61De5b1355Ae4e9d9C786005e9D5BD);\n', '    \n', '    function tokensale(address tokenAddress, uint256 noOfTokens, uint256 prPerToken) {\n', '        dates[0] = 1505520000;\n', '        dates[1] = 1506038400;\n', '        dates[2] = 1506124800;\n', '        dates[3] = 1506816000;\n', '        dates[4] = 1507420800;\n', '        dates[5] = 1508112000;\n', '        dates[6] = 1508630400;\n', '        dates[7] = 1508803200;\n', '        percents[0] = 35000;\n', '        percents[1] = 20000;\n', '        percents[2] = 10000;\n', '        percents[3] = 5000;\n', '        percents[4] = 2500;\n', '        percents[5] = 0;\n', '        percents[6] = 9001;\n', '        percents[7] = 9001;\n', '        token = Token(tokenAddress);\n', '        numberOfTokens = noOfTokens * 100;\n', '        totalSupply = noOfTokens * 100;\n', '        numberOfTokensLeft = noOfTokens * 100;\n', '        pricePerToken = prPerToken;\n', '        owner = msg.sender;\n', '        name = "Autonio ICO";\n', '        symbol = "NIO";\n', '        updatePresaleNumbers();\n', '    }\n', '    \n', '    function addAddress (address addr) private {\n', '        if(!addressExists[addr]) {\n', '            addressIndex[addr] = numberOfAddress;\n', '            addresses[numberOfAddress++] = addr;\n', '            addressExists[addr] = true;\n', '        }\n', '    }\n', '    \n', '    function endPresale() {\n', '        if(msg.sender == owner) {\n', '            if(now > dates[numberOfDates-1]) {\n', '                finish();\n', '            } else if(numberOfTokensLeft == 0) {\n', '                finish();\n', '            } else {\n', '                throw;\n', '            }\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function finish() private {\n', '        if(!finalAddress.send(this.balance)) {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function withdraw(uint256 amount) {\n', '        if(msg.sender == owner) {\n', '            if(amount <= withdrawLimit) {\n', '                withdrawLimit-=amount;\n', '                if(!finalAddress.send(amount)) {\n', '                    throw;\n', '                }\n', '            } else {\n', '                throw;\n', '            }\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function updatePresaleNumbers() {\n', '        if(msg.sender == owner) {\n', '            uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;\n', '            tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();\n', '            uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;\n', '            numberOfTokensLeft -= diff;\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function () payable {\n', '        uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;\n', '        tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();\n', '        uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;\n', '        numberOfTokensLeft -= diff;\n', '        \n', '        uint256 weiSent = msg.value * 100;\n', '        if(weiSent==0) {\n', '            throw;\n', '        }\n', '        uint256 weiLeftOver = 0;\n', '        if(numberOfTokensLeft<=0 || now<dates[0] || now>dates[numberOfDates-1]) {\n', '            throw;\n', '        }\n', '        uint256 percent = 9001;\n', '        for(uint256 i=0;i<numberOfDates-1;i++) {\n', '            if(now>=dates[i] && now<=dates[i+1] ) {\n', '                percent = percents[i];\n', '                i=numberOfDates-1;\n', '            }\n', '        }\n', '        if(percent==9001) {\n', '            throw;\n', '        }\n', '        uint256 tokensToGive = weiSent / pricePerToken;\n', '        if(tokensToGive * pricePerToken > weiSent) tokensToGive--;\n', '        tokensToGive=(tokensToGive*(100000+percent))/100000;\n', '        if(tokensToGive>numberOfTokensLeft) {\n', '            weiLeftOver = (tokensToGive - numberOfTokensLeft) * pricePerToken;\n', '            tokensToGive = numberOfTokensLeft;\n', '        }\n', '        numberOfTokensLeft -= tokensToGive;\n', '        if(addressExists[msg.sender]) {\n', '            balanceOf[msg.sender] += tokensToGive;\n', '        } else {\n', '            addAddress(msg.sender);\n', '            balanceOf[msg.sender] = tokensToGive;\n', '        }\n', '        Transfer(0x0,msg.sender,tokensToGive);\n', '        if(weiLeftOver>0)msg.sender.send(weiLeftOver);\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}']
['pragma solidity ^0.4.10;\n', '\n', 'contract Token {\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (uint256 => address) public addresses;\n', '    mapping (address => bool) public addressExists;\n', '    mapping (address => uint256) public addressIndex;\n', '    uint256 public numberOfAddress = 0;\n', '    \n', '    string public physicalString;\n', '    string public cryptoString;\n', '    \n', '    bool public isSecured;\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    bool public canMintBurn;\n', '    uint256 public txnTax;\n', '    uint256 public holdingTax;\n', '    //In Weeks, on Fridays\n', '    uint256 public holdingTaxInterval;\n', '    uint256 public lastHoldingTax;\n', '    uint256 public holdingTaxDecimals = 2;\n', '    bool public isPrivate;\n', '    \n', '    address public owner;\n', '    \n', '    function Token(string n, string a, uint256 totalSupplyToUse, bool isSecured, bool cMB, string physical, string crypto, uint256 txnTaxToUse, uint256 holdingTaxToUse, uint256 holdingTaxIntervalToUse, bool isPrivateToUse) {\n', '        name = n;\n', '        symbol = a;\n', '        totalSupply = totalSupplyToUse;\n', '        balanceOf[msg.sender] = totalSupplyToUse;\n', '        isSecured = isSecured;\n', '        physicalString = physical;\n', '        cryptoString = crypto;\n', '        canMintBurn = cMB;\n', '        owner = msg.sender;\n', '        txnTax = txnTaxToUse;\n', '        holdingTax = holdingTaxToUse;\n', '        holdingTaxInterval = holdingTaxIntervalToUse;\n', '        if(holdingTaxInterval!=0) {\n', '            lastHoldingTax = now;\n', '            while(getHour(lastHoldingTax)!=21) {\n', '                lastHoldingTax -= 1 hours;\n', '            }\n', '            while(getWeekday(lastHoldingTax)!=5) {\n', '                lastHoldingTax -= 1 days;\n', '            }\n', '            lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);\n', '        }\n', '        isPrivate = isPrivateToUse;\n', '        \n', '        addAddress(owner);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) payable {\n', '        chargeHoldingTax();\n', '        if (balanceOf[msg.sender] < _value) throw;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        if (msg.sender != owner && _to != owner && txnTax != 0) {\n', '            if(!owner.send(txnTax)) {\n', '                throw;\n', '            }\n', '        }\n', '        if(isPrivate && msg.sender != owner && !addressExists[_to]) {\n', '            throw;\n', '        }\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        addAddress(_to);\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    function changeTxnTax(uint256 _newValue) {\n', '        if(msg.sender != owner) throw;\n', '        txnTax = _newValue;\n', '    }\n', '    \n', '    function mint(uint256 _value) {\n', '        if(canMintBurn && msg.sender == owner) {\n', '            if (balanceOf[msg.sender] + _value < balanceOf[msg.sender]) throw;\n', '            balanceOf[msg.sender] += _value;\n', '            totalSupply += _value;\n', '            Transfer(0, msg.sender, _value);\n', '        }\n', '    }\n', '    \n', '    function burn(uint256 _value) {\n', '        if(canMintBurn && msg.sender == owner) {\n', '            if (balanceOf[msg.sender] < _value) throw;\n', '            balanceOf[msg.sender] -= _value;\n', '            totalSupply -= _value;\n', '            Transfer(msg.sender, 0, _value);\n', '        }\n', '    }\n', '    \n', '    function chargeHoldingTax() {\n', '        if(holdingTaxInterval!=0) {\n', '            uint256 dateDif = now - lastHoldingTax;\n', '            bool changed = false;\n', '            while(dateDif >= holdingTaxInterval * (1 weeks)) {\n', '                changed=true;\n', '                dateDif -= holdingTaxInterval * (1 weeks);\n', '                for(uint256 i = 0;i<numberOfAddress;i++) {\n', '                    if(addresses[i]!=owner) {\n', '                        uint256 amtOfTaxToPay = ((balanceOf[addresses[i]]) * holdingTax)  / (10**holdingTaxDecimals)/ (10**holdingTaxDecimals);\n', '                        balanceOf[addresses[i]] -= amtOfTaxToPay;\n', '                        balanceOf[owner] += amtOfTaxToPay;\n', '                    }\n', '                }\n', '            }\n', '            if(changed) {\n', '                lastHoldingTax = now;\n', '                while(getHour(lastHoldingTax)!=21) {\n', '                    lastHoldingTax -= 1 hours;\n', '                }\n', '                while(getWeekday(lastHoldingTax)!=5) {\n', '                    lastHoldingTax -= 1 days;\n', '                }\n', '                lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function changeHoldingTax(uint256 _newValue) {\n', '        if(msg.sender != owner) throw;\n', '        holdingTax = _newValue;\n', '    }\n', '    \n', '    function changeHoldingTaxInterval(uint256 _newValue) {\n', '        if(msg.sender != owner) throw;\n', '        holdingTaxInterval = _newValue;\n', '    }\n', '    \n', '    function addAddress (address addr) private {\n', '        if(!addressExists[addr]) {\n', '            addressIndex[addr] = numberOfAddress;\n', '            addresses[numberOfAddress++] = addr;\n', '            addressExists[addr] = true;\n', '        }\n', '    }\n', '    \n', '    function addAddressManual (address addr) {\n', '        if(msg.sender == owner && isPrivate) {\n', '            addAddress(addr);\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function removeAddress (address addr) private {\n', '        if(addressExists[addr]) {\n', '            numberOfAddress--;\n', '            addresses[addressIndex[addr]] = 0x0;\n', '            addressExists[addr] = false;\n', '        }\n', '    }\n', '    \n', '    function removeAddressManual (address addr) {\n', '        if(msg.sender == owner && isPrivate) {\n', '            removeAddress(addr);\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function getWeekday(uint timestamp) returns (uint8) {\n', '            return uint8((timestamp / 86400 + 4) % 7);\n', '    }\n', '    \n', '    function getHour(uint timestamp) returns (uint8) {\n', '            return uint8((timestamp / 60 / 60) % 24);\n', '    }\n', '\n', '    function getMinute(uint timestamp) returns (uint8) {\n', '            return uint8((timestamp / 60) % 60);\n', '    }\n', '\n', '    function getSecond(uint timestamp) returns (uint8) {\n', '            return uint8(timestamp % 60);\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', 'contract tokensale {\n', '    \n', '    Token public token;\n', '    uint256 public totalSupply;\n', '    uint256 public numberOfTokens;\n', '    uint256 public numberOfTokensLeft;\n', '    uint256 public pricePerToken;\n', '    uint256 public tokensFromPresale = 0;\n', '    uint256 public tokensFromPreviousTokensale = 0;\n', '    uint8 public decimals = 2;\n', '    uint256 public withdrawLimit = 200000000000000000000;\n', '    \n', '    address public owner;\n', '    string public name;\n', '    string public symbol;\n', '    \n', '    address public finalAddress = 0x5904957d25D0c6213491882a64765967F88BCCC7;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => bool) public addressExists;\n', '    mapping (uint256 => address) public addresses;\n', '    mapping (address => uint256) public addressIndex;\n', '    uint256 public numberOfAddress = 0;\n', '    \n', '    mapping (uint256 => uint256) public dates;\n', '    mapping (uint256 => uint256) public percents;\n', '    uint256 public numberOfDates = 8;\n', '    \n', '    tokensale ps = tokensale(0xa67d97d75eE175e05BB1FB17529FD772eE8E9030);\n', '    tokensale pts = tokensale(0xED6c0654cD61De5b1355Ae4e9d9C786005e9D5BD);\n', '    \n', '    function tokensale(address tokenAddress, uint256 noOfTokens, uint256 prPerToken) {\n', '        dates[0] = 1505520000;\n', '        dates[1] = 1506038400;\n', '        dates[2] = 1506124800;\n', '        dates[3] = 1506816000;\n', '        dates[4] = 1507420800;\n', '        dates[5] = 1508112000;\n', '        dates[6] = 1508630400;\n', '        dates[7] = 1508803200;\n', '        percents[0] = 35000;\n', '        percents[1] = 20000;\n', '        percents[2] = 10000;\n', '        percents[3] = 5000;\n', '        percents[4] = 2500;\n', '        percents[5] = 0;\n', '        percents[6] = 9001;\n', '        percents[7] = 9001;\n', '        token = Token(tokenAddress);\n', '        numberOfTokens = noOfTokens * 100;\n', '        totalSupply = noOfTokens * 100;\n', '        numberOfTokensLeft = noOfTokens * 100;\n', '        pricePerToken = prPerToken;\n', '        owner = msg.sender;\n', '        name = "Autonio ICO";\n', '        symbol = "NIO";\n', '        updatePresaleNumbers();\n', '    }\n', '    \n', '    function addAddress (address addr) private {\n', '        if(!addressExists[addr]) {\n', '            addressIndex[addr] = numberOfAddress;\n', '            addresses[numberOfAddress++] = addr;\n', '            addressExists[addr] = true;\n', '        }\n', '    }\n', '    \n', '    function endPresale() {\n', '        if(msg.sender == owner) {\n', '            if(now > dates[numberOfDates-1]) {\n', '                finish();\n', '            } else if(numberOfTokensLeft == 0) {\n', '                finish();\n', '            } else {\n', '                throw;\n', '            }\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function finish() private {\n', '        if(!finalAddress.send(this.balance)) {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function withdraw(uint256 amount) {\n', '        if(msg.sender == owner) {\n', '            if(amount <= withdrawLimit) {\n', '                withdrawLimit-=amount;\n', '                if(!finalAddress.send(amount)) {\n', '                    throw;\n', '                }\n', '            } else {\n', '                throw;\n', '            }\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function updatePresaleNumbers() {\n', '        if(msg.sender == owner) {\n', '            uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;\n', '            tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();\n', '            uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;\n', '            numberOfTokensLeft -= diff;\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '    \n', '    function () payable {\n', '        uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;\n', '        tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();\n', '        uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;\n', '        numberOfTokensLeft -= diff;\n', '        \n', '        uint256 weiSent = msg.value * 100;\n', '        if(weiSent==0) {\n', '            throw;\n', '        }\n', '        uint256 weiLeftOver = 0;\n', '        if(numberOfTokensLeft<=0 || now<dates[0] || now>dates[numberOfDates-1]) {\n', '            throw;\n', '        }\n', '        uint256 percent = 9001;\n', '        for(uint256 i=0;i<numberOfDates-1;i++) {\n', '            if(now>=dates[i] && now<=dates[i+1] ) {\n', '                percent = percents[i];\n', '                i=numberOfDates-1;\n', '            }\n', '        }\n', '        if(percent==9001) {\n', '            throw;\n', '        }\n', '        uint256 tokensToGive = weiSent / pricePerToken;\n', '        if(tokensToGive * pricePerToken > weiSent) tokensToGive--;\n', '        tokensToGive=(tokensToGive*(100000+percent))/100000;\n', '        if(tokensToGive>numberOfTokensLeft) {\n', '            weiLeftOver = (tokensToGive - numberOfTokensLeft) * pricePerToken;\n', '            tokensToGive = numberOfTokensLeft;\n', '        }\n', '        numberOfTokensLeft -= tokensToGive;\n', '        if(addressExists[msg.sender]) {\n', '            balanceOf[msg.sender] += tokensToGive;\n', '        } else {\n', '            addAddress(msg.sender);\n', '            balanceOf[msg.sender] = tokensToGive;\n', '        }\n', '        Transfer(0x0,msg.sender,tokensToGive);\n', '        if(weiLeftOver>0)msg.sender.send(weiLeftOver);\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}']