['pragma solidity ^0.4.19;\n', '\n', 'contract Token {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    \n', '    uint8 public decimals;\n', '}\n', '\n', 'contract Exchange {\n', '    struct Order {\n', '        address creator;\n', '        address token;\n', '        bool buy;\n', '        uint price;\n', '        uint amount;\n', '    }\n', '    \n', '    address public owner;\n', '    uint public feeDeposit = 500;\n', '    \n', '    mapping (uint => Order) orders;\n', '    uint currentOrderId = 0;\n', '    \n', '    /* Token address (0x0 - Ether) => User address => balance */\n', '    mapping (address => mapping (address => uint)) public balanceOf;\n', '    \n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '    \n', '    event PlaceSell(address indexed token, address indexed user, uint price, uint amount, uint id);\n', '    event PlaceBuy(address indexed token, address indexed user, uint price, uint amount, uint id);\n', '    event FillOrder(uint id, uint amount);\n', '    event CancelOrder(uint id);\n', '    event Deposit(address indexed token, address indexed user, uint amount);\n', '    event Withdraw(address indexed token, address indexed user, uint amount);\n', '    event BalanceChanged(address indexed token, address indexed user, uint value);\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) revert();\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function Exchange() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function safeAdd(uint a, uint b) private pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function safeSub(uint a, uint b) private pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    function safeMul(uint a, uint b) private pure returns (uint) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        \n', '        uint c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function decFeeDeposit(uint delta) external onlyOwner {\n', '        feeDeposit = safeSub(feeDeposit, delta);\n', '    }\n', '    \n', '    function calcAmountEther(address tokenAddr, uint price, uint amount) private view returns (uint) {\n', '        uint k = 10;\n', '        k = k ** Token(tokenAddr).decimals();\n', '        return safeMul(amount, price) / k;\n', '    }\n', '    \n', '    function balanceAdd(address tokenAddr, address user, uint amount) private {\n', '        balanceOf[tokenAddr][user] =\n', '            safeAdd(balanceOf[tokenAddr][user], amount);\n', '    }\n', '    \n', '    function balanceSub(address tokenAddr, address user, uint amount) private {\n', '        require(balanceOf[tokenAddr][user] >= amount);\n', '        balanceOf[tokenAddr][user] =\n', '            safeSub(balanceOf[tokenAddr][user], amount);\n', '    }\n', '    \n', '    function placeBuy(address tokenAddr, uint price, uint amount) external {\n', '        require(price > 0 && amount > 0);\n', '        uint amountEther = calcAmountEther(tokenAddr, price, amount);\n', '        require(amountEther > 0);\n', '        balanceSub(0x0, msg.sender, amountEther);\n', '        BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);\n', '        orders[currentOrderId] = Order({\n', '            creator: msg.sender,\n', '            token: tokenAddr,\n', '            buy: true,\n', '            price: price,\n', '            amount: amount\n', '        });\n', '        PlaceBuy(tokenAddr, msg.sender, price, amount, currentOrderId);\n', '        currentOrderId++;\n', '    }\n', '    \n', '    function placeSell(address tokenAddr, uint price, uint amount) external {\n', '        require(price > 0 && amount > 0);\n', '        uint amountEther = calcAmountEther(tokenAddr, price, amount);\n', '        require(amountEther > 0);\n', '        balanceSub(tokenAddr, msg.sender, amount);\n', '        BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);\n', '        orders[currentOrderId] = Order({\n', '            creator: msg.sender,\n', '            token: tokenAddr,\n', '            buy: false,\n', '            price: price,\n', '            amount: amount\n', '        });\n', '        PlaceSell(tokenAddr, msg.sender, price, amount, currentOrderId);\n', '        currentOrderId++;\n', '    }\n', '    \n', '    function fillOrder(uint id, uint amount) external {\n', '        require(id < currentOrderId);\n', '        require(orders[id].creator != msg.sender);\n', '        require(orders[id].amount >= amount);\n', '        uint amountEther = calcAmountEther(orders[id].token, orders[id].price, amount);\n', '        if (orders[id].buy) {\n', '            /* send tokens from sender to creator */\n', '            // sub from sender\n', '            balanceSub(orders[id].token, msg.sender, amount);\n', '            BalanceChanged(\n', '                orders[id].token,\n', '                msg.sender,\n', '                balanceOf[orders[id].token][msg.sender]\n', '            );\n', '            \n', '            // add to creator\n', '            balanceAdd(orders[id].token, orders[id].creator, amount);\n', '            BalanceChanged(\n', '                orders[id].token,\n', '                orders[id].creator,\n', '                balanceOf[orders[id].token][orders[id].creator]\n', '            );\n', '            \n', '            /* send Ether to sender */\n', '            balanceAdd(0x0, msg.sender, amountEther);\n', '            BalanceChanged(\n', '                0x0,\n', '                msg.sender,\n', '                balanceOf[0x0][msg.sender]\n', '            );\n', '        } else {\n', '            /* send Ether from sender to creator */\n', '            // sub from sender\n', '            balanceSub(0x0, msg.sender, amountEther);\n', '            BalanceChanged(\n', '                0x0,\n', '                msg.sender,\n', '                balanceOf[0x0][msg.sender]\n', '            );\n', '            \n', '            // add to creator\n', '            balanceAdd(0x0, orders[id].creator, amountEther);\n', '            BalanceChanged(\n', '                0x0,\n', '                orders[id].creator,\n', '                balanceOf[0x0][orders[id].creator]\n', '            );\n', '            \n', '            /* send tokens to sender */\n', '            balanceAdd(orders[id].token, msg.sender, amount);\n', '            BalanceChanged(\n', '                orders[id].token,\n', '                msg.sender,\n', '                balanceOf[orders[id].token][msg.sender]\n', '            );\n', '        }\n', '        orders[id].amount -= amount;\n', '        FillOrder(id, orders[id].amount);\n', '    }\n', '    \n', '    function cancelOrder(uint id) external {\n', '        require(id < currentOrderId);\n', '        require(orders[id].creator == msg.sender);\n', '        require(orders[id].amount > 0);\n', '        if (orders[id].buy) {\n', '            uint amountEther = calcAmountEther(orders[id].token, orders[id].price, orders[id].amount);\n', '            balanceAdd(0x0, msg.sender, amountEther);\n', '            BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);\n', '        } else {\n', '            balanceAdd(orders[id].token, msg.sender, orders[id].amount);\n', '            BalanceChanged(orders[id].token, msg.sender, balanceOf[orders[id].token][msg.sender]);\n', '        }\n', '        orders[id].amount = 0;\n', '        CancelOrder(id);\n', '    }\n', '    \n', '    function () external payable {\n', '        require(msg.value > 0);\n', '        uint fee = msg.value * feeDeposit / 10000;\n', '        require(msg.value > fee);\n', '        balanceAdd(0x0, owner, fee);\n', '        \n', '        uint toAdd = msg.value - fee;\n', '        balanceAdd(0x0, msg.sender, toAdd);\n', '        \n', '        Deposit(0x0, msg.sender, toAdd);\n', '        BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);\n', '        \n', '        FundTransfer(msg.sender, toAdd, true);\n', '    }\n', '    \n', '    function depositToken(address tokenAddr, uint amount) external {\n', '        require(tokenAddr != 0x0);\n', '        require(amount > 0);\n', '        Token(tokenAddr).transferFrom(msg.sender, this, amount);\n', '        balanceAdd(tokenAddr, msg.sender, amount);\n', '        \n', '        Deposit(tokenAddr, msg.sender, amount);\n', '        BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);\n', '    }\n', '    \n', '    function withdrawEther(uint amount) external {\n', '        require(amount > 0);\n', '        balanceSub(0x0, msg.sender, amount);\n', '        msg.sender.transfer(amount);\n', '        \n', '        Withdraw(0x0, msg.sender, amount);\n', '        BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);\n', '        \n', '        FundTransfer(msg.sender, amount, false);\n', '    }\n', '    \n', '    function withdrawToken(address tokenAddr, uint amount) external {\n', '        require(tokenAddr != 0x0);\n', '        require(amount > 0);\n', '        balanceSub(tokenAddr, msg.sender, amount);\n', '        Token(tokenAddr).transfer(msg.sender, amount);\n', '        \n', '        Withdraw(tokenAddr, msg.sender, amount);\n', '        BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);\n', '    }\n', '}']