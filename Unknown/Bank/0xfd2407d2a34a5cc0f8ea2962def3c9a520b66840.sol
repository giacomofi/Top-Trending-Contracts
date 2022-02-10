['contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract MyToken {\n', '    uint8 public decimals;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    function MyToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        );\n', '    function transfer(address _to, uint256 _value);\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', 'contract DTE {\n', "    string public standard = 'Token 0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    uint public amountOfHolders;\n', '    uint public totalSellOrders;\n', '    uint public totalBuyOrders;\n', '    uint public totalTokens;\n', '    uint public totalDividendPayOuts;\n', '    string public solidityCompileVersion = "v0.3.6-2016-09-08-acd334c";\n', '    string public takerFeePercent = "1%";\n', '    string public tokenAddFee = "0.1 ether";\n', '\n', '    struct sellOrder {\n', '        bool isOpen;\n', '        bool isTaken;\n', '        address seller;\n', '        uint soldTokenNo;\n', '        uint boughtTokenNo;\n', '        uint256 soldAmount;\n', '        uint256 boughtAmount;\n', '    }\n', '    \n', '    struct buyOrder {\n', '        bool isOpen;\n', '        bool isTaken;\n', '        address buyer;\n', '        uint soldTokenNo;\n', '        uint boughtTokenNo;\n', '        uint256 soldAmount;\n', '        uint256 boughtAmount;\n', '    }\n', '\n', '    mapping (uint => MyToken) public tokensAddress;\n', '    mapping (address => uint) public tokenNoByAddress;\n', '    mapping (uint => sellOrder) public sellOrders;\n', '    mapping (uint => buyOrder) public buyOrders;\n', '    mapping (address => uint) public totalBuyOrdersOf;\n', '    mapping (address => uint) public totalSellOrdersOf;\n', '    mapping (address => mapping(uint => uint)) public BuyOrdersOf;\n', '    mapping (address => mapping(uint => uint)) public SellOrdersOf;\n', '    mapping (uint => uint256) public collectedFees;\n', '    mapping (address => mapping(uint => uint256)) public claimableFeesOf;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (uint => address) public shareHolderByNumber;\n', '    mapping (address => uint) public shareHolderByAddress;\n', '    mapping (address => bool) isHolder;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event SellOrder(uint indexed OrderNo, address indexed Seller, uint SoldTokenNo, uint256 SoldAmount, uint BoughtTokenNo, uint256 BoughtAmount);\n', '    event BuyOrder(uint indexed OrderNo, address indexed Buyer, uint SoldTokenNo, uint256 SoldAmount, uint BoughtTokenNo, uint256 BoughtAmount);\n', '    event OrderTake(uint indexed OrderNo);\n', '    event CancelOrder(uint indexed OrderNo);\n', '    event TokenAdd(uint indexed TokenNumber, address indexed TokenAddress);\n', '    event DividendDistribution(uint indexed TokenNumber, uint256 totalAmount);\n', '\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;\n', '        if (_value == 0) throw;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        if(isHolder[_to] && balanceOf[msg.sender] == _value) {\n', '            isHolder[msg.sender] = false;\n', '            shareHolderByAddress[_to] = shareHolderByAddress[msg.sender];\n', '            shareHolderByNumber[shareHolderByAddress[_to]] = _to;\n', '        } else if(isHolder[_to] == false && balanceOf[msg.sender] == _value) {\n', '            isHolder[msg.sender] = false;\n', '            isHolder[_to] = true;\n', '            shareHolderByAddress[_to] = shareHolderByAddress[msg.sender];\n', '            shareHolderByNumber[shareHolderByAddress[_to]] = _to;\n', '        } else if(isHolder[_to] == false) {\n', '            isHolder[_to] = true;\n', '            amountOfHolders = amountOfHolders + 1;\n', '            shareHolderByAddress[_to] = amountOfHolders;\n', '            shareHolderByNumber[amountOfHolders] = _to;\n', '        }\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balanceOf[_from] < _value) throw;\n', '        if (_value == 0) throw;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        if (_value > allowance[_from][msg.sender]) throw;\n', '        if(isHolder[_to] && balanceOf[_from] == _value) {\n', '            isHolder[_from] = false;\n', '            shareHolderByAddress[_to] = shareHolderByAddress[_from];\n', '            shareHolderByNumber[shareHolderByAddress[_to]] = _to;\n', '        } else if(isHolder[_to] == false && balanceOf[_from] == _value) {\n', '            isHolder[_from] = false;\n', '            isHolder[_to] = true;\n', '            shareHolderByAddress[_to] = shareHolderByAddress[_from];\n', '            shareHolderByNumber[shareHolderByAddress[_to]] = _to;\n', '        } else if(isHolder[_to] == false) {\n', '            isHolder[_to] = true;\n', '            amountOfHolders = amountOfHolders + 1;\n', '            shareHolderByAddress[_to] = amountOfHolders;\n', '            shareHolderByNumber[amountOfHolders] = _to;\n', '        }\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function DTE() {\n', '        balanceOf[msg.sender] = 100000000000000000000;\n', '        amountOfHolders = amountOfHolders + 1;\n', '        shareHolderByNumber[amountOfHolders] = msg.sender;\n', '        shareHolderByAddress[msg.sender] = amountOfHolders;\n', '        isHolder[msg.sender] = true;\n', '        totalSupply = 100000000000000000000;\n', '        name = "DTE Shares";\n', '        symbol = "%";\n', '        decimals = 18;\n', '        tokensAddress[++totalTokens] = MyToken(this);\n', '        tokenNoByAddress[address(this)] = totalTokens;\n', '    }\n', '\n', '    function DistributeDividends(uint token) {\n', '        if((collectedFees[token] / 100000000000000000000) < 1) throw;\n', '        for(uint i = 1; i < amountOfHolders+1; i++) {\n', '            if(shareHolderByNumber[i] == address(this)) {\n', '                collectedFees[token] += (collectedFees[token] * balanceOf[shareHolderByNumber[i]]) / 100000000000000000000;\n', '            } else {\n', '                claimableFeesOf[shareHolderByNumber[i]][token] += (collectedFees[token] * balanceOf[shareHolderByNumber[i]]) / 100000000000000000000;\n', '            }\n', '        }\n', '        DividendDistribution(token, collectedFees[token]);\n', '        collectedFees[token] = 0;\n', '    }\n', '\n', '    function claimDividendShare(uint tokenNo) {\n', '        if(tokenNo == 0) {\n', '            msg.sender.send(claimableFeesOf[msg.sender][0]);\n', '            claimableFeesOf[msg.sender][0] = 0;\n', '        } else if(tokenNo != 0){\n', '            var token = MyToken(tokensAddress[tokenNo]);\n', '            token.transfer(msg.sender, claimableFeesOf[msg.sender][tokenNo]);\n', '            claimableFeesOf[msg.sender][0] = 0;\n', '        }\n', '    }\n', '\n', '    function () {\n', '        if(msg.value > 0) collectedFees[0] += msg.value;\n', '    }\n', '\n', '    function addToken(address tokenContractAddress) {\n', '        if(msg.value < 100 finney) throw;\n', '        if(tokenNoByAddress[tokenContractAddress] != 0) throw;\n', '        msg.sender.send(msg.value - 100 finney);\n', '        collectedFees[0] += 100 finney;\n', '        tokensAddress[++totalTokens] = MyToken(tokenContractAddress);\n', '        tokenNoByAddress[tokenContractAddress] = totalTokens;\n', '        TokenAdd(totalTokens, tokenContractAddress);\n', '    }\n', '\n', '    function cancelOrder(bool isSellOrder, uint orderNo) {\n', '        if(isSellOrder) {\n', '            if(sellOrders[orderNo].seller != msg.sender) throw;\n', '            sellOrders[orderNo].isOpen = false;\n', '            tokensAddress[sellOrders[orderNo].soldTokenNo].transfer(msg.sender, sellOrders[orderNo].soldAmount);\n', '        } else {\n', '            if(buyOrders[orderNo].buyer != msg.sender) throw;\n', '            buyOrders[orderNo].isOpen = false;\n', '            if(buyOrders[orderNo].soldTokenNo == 0) {\n', '                msg.sender.send(buyOrders[orderNo].soldAmount);\n', '            } else {\n', '                tokensAddress[buyOrders[orderNo].soldTokenNo].transfer(msg.sender, buyOrders[orderNo].soldAmount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function takeOrder(bool isSellOrder, uint orderNo, uint256 amount) {\n', '        if(isSellOrder) {\n', '            if(sellOrders[orderNo].isOpen == false) throw;\n', '            var sorder = sellOrders[orderNo];\n', '            uint wantedToken = sorder.boughtTokenNo;\n', '            uint soldToken = sorder.soldTokenNo;\n', '            uint256 soldAmount = sorder.soldAmount;\n', '            uint256 wantedAmount = sorder.boughtAmount;\n', '            if(wantedToken == 0) {\n', '                if(msg.value > (amount + (amount / 100)) || msg.value < amount || msg.value < (amount + (amount / 100)) || amount > wantedAmount) throw;\n', '                if(amount == wantedAmount) {\n', '                    sorder.isTaken = true;\n', '                    sorder.isOpen = false;\n', '                    sorder.seller.send(amount);\n', '                    collectedFees[0] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, sorder.soldAmount);\n', '                } else {\n', '                    uint256 transferAmount = uint256((int(amount) * int(sorder.soldAmount)) / int(sorder.boughtAmount));\n', '                    sorder.soldAmount -= transferAmount;\n', '                    sorder.boughtAmount -= amount;\n', '                    sorder.seller.send(amount);\n', '                    collectedFees[0] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);\n', '                }\n', '            } else {\n', '                if(msg.value > 0) throw;\n', '                uint256 allowance = tokensAddress[wantedToken].allowance(msg.sender, this);\n', '                if(allowance > (amount + (amount / 100)) || allowance < amount || allowance < (amount + (amount / 100)) || amount > wantedAmount) throw;\n', '                if(amount == wantedAmount) {\n', '                    sorder.isTaken = true;\n', '                    sorder.isOpen = false;\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, sorder.seller, amount);\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));\n', '                    collectedFees[wantedToken] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, sorder.soldAmount);\n', '                } else {\n', '                    transferAmount = uint256((int(amount) * int(sorder.soldAmount)) / int(sorder.boughtAmount));\n', '                    sorder.soldAmount -= transferAmount;\n', '                    sorder.boughtAmount -= amount;\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, sorder.seller, amount);\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));\n', '                    collectedFees[wantedToken] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);\n', '                }\n', '            }\n', '        } else {\n', '            if(buyOrders[orderNo].isOpen == false) throw;\n', '            var border = buyOrders[orderNo];\n', '            wantedToken = border.boughtTokenNo;\n', '            soldToken = border.soldTokenNo;\n', '            soldAmount = border.soldAmount;\n', '            wantedAmount = border.boughtAmount;\n', '            if(wantedToken == 0) {\n', '                if(msg.value > (amount + (amount / 100)) || msg.value < amount || msg.value < (amount + (amount / 100)) || amount > wantedAmount) throw;\n', '                if(amount == wantedAmount) {\n', '                    border.isTaken = true;\n', '                    border.isOpen = false;\n', '                    border.buyer.send(amount);\n', '                    collectedFees[0] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, border.soldAmount);\n', '                } else {\n', '                    transferAmount = uint256((int(amount) * int(border.soldAmount)) / int(border.boughtAmount));\n', '                    border.soldAmount -= transferAmount;\n', '                    border.boughtAmount -= amount;\n', '                    border.buyer.send(amount);\n', '                    collectedFees[0] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);\n', '                }\n', '            } else {\n', '                if(msg.value > 0) throw;\n', '                allowance = tokensAddress[wantedToken].allowance(msg.sender, this);\n', '                if(allowance > (amount + (amount / 100)) || allowance < amount || allowance < (amount + (amount / 100)) || amount > wantedAmount) throw;\n', '                if(amount == wantedAmount) {\n', '                    border.isTaken = true;\n', '                    border.isOpen = false;\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, border.buyer, amount);\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));\n', '                    collectedFees[wantedToken] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, border.soldAmount);\n', '                } else {\n', '                    transferAmount = uint256((int(amount) * int(border.soldAmount)) / int(border.boughtAmount));\n', '                    border.soldAmount -= transferAmount;\n', '                    border.boughtAmount -= amount;\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, border.buyer, amount);\n', '                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));\n', '                    collectedFees[wantedToken] += amount / 100;\n', '                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function newOrder(bool isSellOrder,\n', '                      uint soldTokenNo,\n', '                      uint boughtTokenNo,\n', '                      uint256 soldAmount,\n', '                      uint256 boughtAmount\n', '                      ) {\n', '        if(soldTokenNo == boughtTokenNo) throw;\n', '        if(isSellOrder) {\n', '            if(soldTokenNo == 0) throw;\n', '            MyToken token = tokensAddress[soldTokenNo];\n', '            uint256 allowance = token.allowance(msg.sender, this);\n', '            if(soldTokenNo > totalTokens || allowance < soldAmount) throw;\n', '            token.transferFrom(msg.sender, this, soldAmount);\n', '            sellOrders[++totalSellOrders] = sellOrder({\n', '                isOpen: true,\n', '                isTaken: false,\n', '                seller: msg.sender,\n', '                soldTokenNo: soldTokenNo,\n', '                boughtTokenNo: boughtTokenNo,\n', '                soldAmount: soldAmount,\n', '                boughtAmount: boughtAmount\n', '            });\n', '            SellOrdersOf[msg.sender][++totalSellOrdersOf[msg.sender]] = totalSellOrders;\n', '            SellOrder(totalSellOrders, msg.sender, soldTokenNo, soldAmount, boughtTokenNo, boughtAmount);\n', '        } else {\n', '            if(soldTokenNo == 0)  {\n', '                if(msg.value > soldAmount) throw;\n', '                allowance = msg.value;\n', '            } else if(soldTokenNo > totalTokens) {\n', '                throw;\n', '            } else {\n', '                token = tokensAddress[soldTokenNo];\n', '                allowance = token.allowance(msg.sender, this);\n', '                if(soldAmount < allowance) throw;\n', '                token.transferFrom(msg.sender, this, soldAmount);\n', '            }\n', '            buyOrders[++totalBuyOrders] = buyOrder({\n', '                isOpen: true,\n', '                isTaken: false,\n', '                buyer: msg.sender,\n', '                soldTokenNo: soldTokenNo,\n', '                boughtTokenNo: boughtTokenNo,\n', '                soldAmount: soldAmount,\n', '                boughtAmount: boughtAmount\n', '            });\n', '            BuyOrdersOf[msg.sender][++totalBuyOrdersOf[msg.sender]] = totalBuyOrders;\n', '            BuyOrder(totalSellOrders, msg.sender, soldTokenNo, soldAmount, boughtTokenNo, boughtAmount);\n', '        }\n', '    }\n', '}']