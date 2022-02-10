['pragma solidity ^0.4.21;\n', '\n', '// ERC20 contract which has the dividend shares of Ethopolis in it \n', '// The old contract had a bug in it, thanks to ccashwell for notifying.\n', '// Contact: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="3451405c514653414d7459555d581a575b59">[email&#160;protected]</a> \n', '// ethopolis.io \n', '// etherguy.surge.sh [if the .io site is up this might be outdated, one of those sites will be up-to-date]\n', '// Selling tokens (and buying them) will be online at etherguy.surge.sh/dividends.html and might be moved to the ethopolis site.\n', '\n', 'contract Dividends {\n', '\n', '    string public name = "Ethopolis Shares";      //  token name\n', '    string public symbol = "EPS";           //  token symbol\n', '    uint256 public decimals = 18;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 10000000* (10 ** uint256(decimals));\n', '    \n', '    uint256 SellFee = 1250; // max is 10 000\n', '\n', '\n', '    address owner = 0x0;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function Dividends() public {\n', '        owner = msg.sender;\n', '\n', '\n', '        // PREMINED TOKENS \n', '        \n', '        // EG\n', '        balanceOf[ address(0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58)] =  8000000* (10 ** uint256(decimals));// was: TokenSupply - 400000;\n', '        // HE\n', '        balanceOf[ address(0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285)] = 200000* (10 ** uint256(decimals));\n', '        // PG\n', '        balanceOf[ address(0x26581d1983ced8955C170eB4d3222DCd3845a092)] = 200000* (10 ** uint256(decimals));\n', '\n', '        // BOUGHT tokens in the OLD contract         \n', '        balanceOf[ address(0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0)] = 97000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x4f0d861281161f39c62B790995fb1e7a0B81B07b)] = 199800* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x36E058332aE39efaD2315776B9c844E30d07388B)] =  20000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c)] =  40000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF)] =  20000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x0a3239799518E7F7F339867A4739282014b97Dcf)] = 499000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x29A9c76aD091c015C12081A1B201c3ea56884579)] = 600000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C)] = 100000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x0982a0bf061f3cec2a004b4d2c802F479099C971)] =  20000* (10 ** uint256(decimals));\n', '        \n', '        balanceOf [address(\t0xA78EfC3A01CB8f2F47137B97f9546B46275f54a6)] =  3000* (10 ** uint256(decimals));\n', '        balanceOf [address(\t0x522273122b20212FE255875a4737b6F50cc72006)] =  1000* (10 ** uint256(decimals));\n', '        balanceOf [address(\t0xc1c51098ff73f311ECD6E855e858225F531812c4)] =  200* (10 ** uint256(decimals));\n', '\n', '        // Etherscan likes it very much if we emit these events \n', '        emit Transfer(0x0, 0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58, 8000000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285, 200000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x26581d1983ced8955C170eB4d3222DCd3845a092, 200000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0, 97000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x4f0d861281161f39c62B790995fb1e7a0B81B07b, 199800* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x36E058332aE39efaD2315776B9c844E30d07388B, 20000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c, 40000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF, 20000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x0a3239799518E7F7F339867A4739282014b97Dcf, 499000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x29A9c76aD091c015C12081A1B201c3ea56884579, 600000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C, 100000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x0982a0bf061f3cec2a004b4d2c802F479099C971, 20000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0xA78EfC3A01CB8f2F47137B97f9546B46275f54a6, 3000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x522273122b20212FE255875a4737b6F50cc72006, 1000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0xc1c51098ff73f311ECD6E855e858225F531812c4, 200* (10 ** uint256(decimals)));\n', '       \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)  public validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // after transfer have enough to pay sell order \n', '        require(sub(balanceOf[msg.sender], SellOrders[msg.sender][0]) >= _value);\n', '        require(msg.sender != _to);\n', '\n', '        uint256 _toBal = balanceOf[_to];\n', '        uint256 _fromBal = balanceOf[msg.sender];\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        \n', '        uint256 _sendFrom = _withdraw(msg.sender, _fromBal, false,0);\n', '        uint256 _sendTo = _withdraw(_to, _toBal, false, _sendFrom);\n', '        \n', '        msg.sender.transfer(_sendFrom);\n', '        _to.transfer(_sendTo);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    // forcetransfer does not do any withdrawals\n', '    function _forceTransfer(address _from, address _to, uint256  _value) internal validAddress {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {\n', '                // after transfer have enough to pay sell order \n', '        require(_from != _to);\n', '        require(sub(balanceOf[_from], SellOrders[_from][0]) >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        uint256 _toBal = balanceOf[_to];\n', '        uint256 _fromBal = balanceOf[_from];\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        // Call withdrawal of old amounts \n', '        CancelOrder();\n', '        uint256 _sendFrom = _withdraw(_from, _fromBal,false,0);\n', '        uint256 _sendTo = _withdraw(_to, _toBal,false,_sendTo);\n', '        \n', '        _from.transfer(_sendFrom);\n', '        _to.transfer(_sendTo);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function setSymbol(string _symb) public isOwner {\n', '        symbol = _symb;\n', '    }\n', '\n', '    function setName(string _name) public isOwner {\n', '        name = _name;\n', '    }\n', '    \n', '    function newOwner(address who) public isOwner validAddress {\n', '        owner = who;\n', '    }\n', '    \n', '    function setFee(uint256 fee) public isOwner {\n', '        require (fee <= 2500);\n', '        SellFee = fee;\n', '    }\n', '\n', '\n', '// Market stuff start \n', '    \n', '    mapping(address => uint256[2]) public SellOrders;\n', '    mapping(address => uint256) public LastBalanceWithdrawn;\n', '    uint256 TotalOut;\n', '    \n', '    function Withdraw() public{\n', '        _withdraw(msg.sender, balanceOf[msg.sender], true,0);\n', '    }\n', '    \n', '    function ViewSellOrder(address who) public view returns (uint256, uint256){\n', '        return (SellOrders[who][0], SellOrders[who][1]);\n', '    }\n', '    \n', '    // if dosend is set to false then the calling function MUST send the fees \n', '    // subxtra is to handle the "high LastBalanceWithdrawn bug" \n', '    // this bug was caused because the Buyer actually gets a too high LastBalanceWithdrawn;\n', '    // this is a minor bug and could be fixed by adding these funds to the contract (which is usually not a large amount)\n', '    // if the contract gets a lot of divs live then that should not be an issue because any new withdrawal will set it to a right value \n', '    // anyways it is fixed now \n', '    function _withdraw(address to, uint256 tkns, bool dosend, uint256 subxtra) internal returns (uint256){\n', '        // calculate how much wei you get \n', '        if (tkns == 0){\n', '            // ok we just reset the timer then \n', '            LastBalanceWithdrawn[msg.sender] = sub(sub(add(address(this).balance, TotalOut),msg.value),subxtra);\n', '            return 0;\n', '        }\n', '        // remove msg.value is exists. if it is nonzero then the call came from Buy, do not include this in balance. \n', '        uint256 total_volume_in = address(this).balance + TotalOut - msg.value;\n', '        // get volume in since last withdrawal; \n', '        uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[to]);\n', '        \n', '        uint256 Get = (tkns * Delta) / totalSupply;\n', '        \n', '        TotalOut = TotalOut + Get;\n', '        \n', '        LastBalanceWithdrawn[to] = sub(sub(sub(add(address(this).balance, TotalOut), Get),msg.value),subxtra);\n', '        \n', '        emit WithdrawalComplete(to, Get);\n', '        if (dosend){\n', '            to.transfer(Get);\n', '            return 0;\n', '        }\n', '        else{//7768\n', '            return Get;\n', '        }\n', '        \n', '    }\n', '    \n', '    function GetDivs(address who) public view returns (uint256){\n', '         uint256 total_volume_in = address(this).balance + TotalOut;\n', '         uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[who]);\n', '         uint256 Get = (balanceOf[who] * Delta) / totalSupply;\n', '         return (Get);\n', '    }\n', '    \n', '    function CancelOrder() public {\n', '        _cancelOrder(msg.sender);\n', '    }\n', '    \n', '    function _cancelOrder(address target) internal{\n', '         SellOrders[target][0] = 0;\n', '         emit SellOrderCancelled(target);\n', '    }\n', '    \n', '    \n', '    // the price is per 10^decimals tokens \n', '    function PlaceSellOrder(uint256 amount, uint256 price) public {\n', '        require(price > 0);\n', '        require(balanceOf[msg.sender] >= amount);\n', '        SellOrders[msg.sender] = [amount, price];\n', '        emit SellOrderPlaced(msg.sender, amount, price);\n', '    }\n', '\n', '    // Safe buy order where user specifies the max amount to buy and the max price; prevents snipers changing their price \n', '    function Buy(address target, uint256 maxamount, uint256 maxprice) public payable {\n', '        require(SellOrders[target][0] > 0);\n', '        require(SellOrders[target][1] <= maxprice);\n', '        uint256 price = SellOrders[target][1];\n', '        uint256 amount_buyable = (mul(msg.value, uint256(10**decimals))) / price; \n', '        \n', '        // decide how much we buy \n', '        \n', '        if (amount_buyable > SellOrders[target][0]){\n', '            amount_buyable = SellOrders[target][0];\n', '        }\n', '        if (amount_buyable > maxamount){\n', '            amount_buyable = maxamount;\n', '        }\n', '        //10000000000000000000,14999999999999\n', '        //"0xca35b7d915458ef540ade6068dfe2f44e8fa733c",10000000000000000000,14999999999999\n', '        uint256 total_payment = mul(amount_buyable, price) / (uint256(10 ** decimals));\n', '        \n', '        // Let&#39;s buy tokens and actually pay, okay?\n', '        require(amount_buyable > 0 && total_payment > 0); \n', '        \n', '        // From the amount we actually pay, we take exchange fee from it \n', '        \n', '        uint256 Fee = mul(total_payment, SellFee) / 10000;\n', '        uint256 Left = total_payment - Fee; \n', '        \n', '        uint256 Excess = msg.value - total_payment;\n', '        \n', '        uint256 OldTokensSeller = balanceOf[target];\n', '        uint256 OldTokensBuyer = balanceOf[msg.sender];\n', '\n', '        // Change it in memory \n', '        _forceTransfer(target, msg.sender, amount_buyable);\n', '        \n', '        // Pay out withdrawals and reset timer\n', '        // Prevents double withdrawals in same tx\n', '        \n', '        // Change sell order \n', '        SellOrders[target][0] = sub(SellOrders[target][0],amount_buyable);\n', '        \n', '        \n', '        // start all transfer stuff \n', '\n', '        uint256 _sendTarget = _withdraw(target, OldTokensSeller, false,0);\n', '        uint256 _sendBuyer = _withdraw(msg.sender, OldTokensBuyer, false, _sendTarget);\n', '        \n', '        // in one transfer saves gas, but its not nice in the etherscan logs \n', '        target.transfer(add(Left, _sendTarget));\n', '        \n', '        if (add(Excess, _sendBuyer) > 0){\n', '            msg.sender.transfer(add(Excess,_sendBuyer));\n', '        }\n', '        \n', '        if (Fee > 0){\n', '            owner.transfer(Fee);\n', '        }\n', '     \n', '        emit SellOrderFilled(msg.sender, target, amount_buyable,  price, Left);\n', '    }\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event SellOrderPlaced(address who, uint256 available, uint256 price);\n', '    event SellOrderFilled(address buyer, address seller, uint256 tokens, uint256 price, uint256 payment);\n', '    event SellOrderCancelled(address who);\n', '    event WithdrawalComplete(address who, uint256 got);\n', '    \n', '    \n', '    // thanks for divs \n', '    function() public payable{\n', '        \n', '    }\n', '    \n', '    // safemath \n', '    \n', '      function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// ERC20 contract which has the dividend shares of Ethopolis in it \n', '// The old contract had a bug in it, thanks to ccashwell for notifying.\n', '// Contact: etherguy@mail.com \n', '// ethopolis.io \n', '// etherguy.surge.sh [if the .io site is up this might be outdated, one of those sites will be up-to-date]\n', '// Selling tokens (and buying them) will be online at etherguy.surge.sh/dividends.html and might be moved to the ethopolis site.\n', '\n', 'contract Dividends {\n', '\n', '    string public name = "Ethopolis Shares";      //  token name\n', '    string public symbol = "EPS";           //  token symbol\n', '    uint256 public decimals = 18;            //  token digit\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 10000000* (10 ** uint256(decimals));\n', '    \n', '    uint256 SellFee = 1250; // max is 10 000\n', '\n', '\n', '    address owner = 0x0;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '    modifier validAddress {\n', '        assert(0x0 != msg.sender);\n', '        _;\n', '    }\n', '\n', '    function Dividends() public {\n', '        owner = msg.sender;\n', '\n', '\n', '        // PREMINED TOKENS \n', '        \n', '        // EG\n', '        balanceOf[ address(0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58)] =  8000000* (10 ** uint256(decimals));// was: TokenSupply - 400000;\n', '        // HE\n', '        balanceOf[ address(0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285)] = 200000* (10 ** uint256(decimals));\n', '        // PG\n', '        balanceOf[ address(0x26581d1983ced8955C170eB4d3222DCd3845a092)] = 200000* (10 ** uint256(decimals));\n', '\n', '        // BOUGHT tokens in the OLD contract         \n', '        balanceOf[ address(0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0)] = 97000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x4f0d861281161f39c62B790995fb1e7a0B81B07b)] = 199800* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x36E058332aE39efaD2315776B9c844E30d07388B)] =  20000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c)] =  40000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF)] =  20000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x0a3239799518E7F7F339867A4739282014b97Dcf)] = 499000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x29A9c76aD091c015C12081A1B201c3ea56884579)] = 600000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C)] = 100000* (10 ** uint256(decimals));\n', '        balanceOf[ address(0x0982a0bf061f3cec2a004b4d2c802F479099C971)] =  20000* (10 ** uint256(decimals));\n', '        \n', '        balanceOf [address(\t0xA78EfC3A01CB8f2F47137B97f9546B46275f54a6)] =  3000* (10 ** uint256(decimals));\n', '        balanceOf [address(\t0x522273122b20212FE255875a4737b6F50cc72006)] =  1000* (10 ** uint256(decimals));\n', '        balanceOf [address(\t0xc1c51098ff73f311ECD6E855e858225F531812c4)] =  200* (10 ** uint256(decimals));\n', '\n', '        // Etherscan likes it very much if we emit these events \n', '        emit Transfer(0x0, 0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58, 8000000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285, 200000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x26581d1983ced8955C170eB4d3222DCd3845a092, 200000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0, 97000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x4f0d861281161f39c62B790995fb1e7a0B81B07b, 199800* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x36E058332aE39efaD2315776B9c844E30d07388B, 20000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x1f2672E17fD7Ec4b52B7F40D41eC5C477fe85c0c, 40000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0xedDaD54E9e1F8dd01e815d84b255998a0a901BbF, 20000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x0a3239799518E7F7F339867A4739282014b97Dcf, 499000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x29A9c76aD091c015C12081A1B201c3ea56884579, 600000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x0668deA6B5ec94D7Ce3C43Fe477888eee2FC1b2C, 100000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x0982a0bf061f3cec2a004b4d2c802F479099C971, 20000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0xA78EfC3A01CB8f2F47137B97f9546B46275f54a6, 3000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0x522273122b20212FE255875a4737b6F50cc72006, 1000* (10 ** uint256(decimals)));\n', '        emit Transfer(0x0, 0xc1c51098ff73f311ECD6E855e858225F531812c4, 200* (10 ** uint256(decimals)));\n', '       \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)  public validAddress returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // after transfer have enough to pay sell order \n', '        require(sub(balanceOf[msg.sender], SellOrders[msg.sender][0]) >= _value);\n', '        require(msg.sender != _to);\n', '\n', '        uint256 _toBal = balanceOf[_to];\n', '        uint256 _fromBal = balanceOf[msg.sender];\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        \n', '        uint256 _sendFrom = _withdraw(msg.sender, _fromBal, false,0);\n', '        uint256 _sendTo = _withdraw(_to, _toBal, false, _sendFrom);\n', '        \n', '        msg.sender.transfer(_sendFrom);\n', '        _to.transfer(_sendTo);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    // forcetransfer does not do any withdrawals\n', '    function _forceTransfer(address _from, address _to, uint256  _value) internal validAddress {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {\n', '                // after transfer have enough to pay sell order \n', '        require(_from != _to);\n', '        require(sub(balanceOf[_from], SellOrders[_from][0]) >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        uint256 _toBal = balanceOf[_to];\n', '        uint256 _fromBal = balanceOf[_from];\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        // Call withdrawal of old amounts \n', '        CancelOrder();\n', '        uint256 _sendFrom = _withdraw(_from, _fromBal,false,0);\n', '        uint256 _sendTo = _withdraw(_to, _toBal,false,_sendTo);\n', '        \n', '        _from.transfer(_sendFrom);\n', '        _to.transfer(_sendTo);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public validAddress returns (bool success) {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0);\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function setSymbol(string _symb) public isOwner {\n', '        symbol = _symb;\n', '    }\n', '\n', '    function setName(string _name) public isOwner {\n', '        name = _name;\n', '    }\n', '    \n', '    function newOwner(address who) public isOwner validAddress {\n', '        owner = who;\n', '    }\n', '    \n', '    function setFee(uint256 fee) public isOwner {\n', '        require (fee <= 2500);\n', '        SellFee = fee;\n', '    }\n', '\n', '\n', '// Market stuff start \n', '    \n', '    mapping(address => uint256[2]) public SellOrders;\n', '    mapping(address => uint256) public LastBalanceWithdrawn;\n', '    uint256 TotalOut;\n', '    \n', '    function Withdraw() public{\n', '        _withdraw(msg.sender, balanceOf[msg.sender], true,0);\n', '    }\n', '    \n', '    function ViewSellOrder(address who) public view returns (uint256, uint256){\n', '        return (SellOrders[who][0], SellOrders[who][1]);\n', '    }\n', '    \n', '    // if dosend is set to false then the calling function MUST send the fees \n', '    // subxtra is to handle the "high LastBalanceWithdrawn bug" \n', '    // this bug was caused because the Buyer actually gets a too high LastBalanceWithdrawn;\n', '    // this is a minor bug and could be fixed by adding these funds to the contract (which is usually not a large amount)\n', '    // if the contract gets a lot of divs live then that should not be an issue because any new withdrawal will set it to a right value \n', '    // anyways it is fixed now \n', '    function _withdraw(address to, uint256 tkns, bool dosend, uint256 subxtra) internal returns (uint256){\n', '        // calculate how much wei you get \n', '        if (tkns == 0){\n', '            // ok we just reset the timer then \n', '            LastBalanceWithdrawn[msg.sender] = sub(sub(add(address(this).balance, TotalOut),msg.value),subxtra);\n', '            return 0;\n', '        }\n', '        // remove msg.value is exists. if it is nonzero then the call came from Buy, do not include this in balance. \n', '        uint256 total_volume_in = address(this).balance + TotalOut - msg.value;\n', '        // get volume in since last withdrawal; \n', '        uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[to]);\n', '        \n', '        uint256 Get = (tkns * Delta) / totalSupply;\n', '        \n', '        TotalOut = TotalOut + Get;\n', '        \n', '        LastBalanceWithdrawn[to] = sub(sub(sub(add(address(this).balance, TotalOut), Get),msg.value),subxtra);\n', '        \n', '        emit WithdrawalComplete(to, Get);\n', '        if (dosend){\n', '            to.transfer(Get);\n', '            return 0;\n', '        }\n', '        else{//7768\n', '            return Get;\n', '        }\n', '        \n', '    }\n', '    \n', '    function GetDivs(address who) public view returns (uint256){\n', '         uint256 total_volume_in = address(this).balance + TotalOut;\n', '         uint256 Delta = sub(total_volume_in, LastBalanceWithdrawn[who]);\n', '         uint256 Get = (balanceOf[who] * Delta) / totalSupply;\n', '         return (Get);\n', '    }\n', '    \n', '    function CancelOrder() public {\n', '        _cancelOrder(msg.sender);\n', '    }\n', '    \n', '    function _cancelOrder(address target) internal{\n', '         SellOrders[target][0] = 0;\n', '         emit SellOrderCancelled(target);\n', '    }\n', '    \n', '    \n', '    // the price is per 10^decimals tokens \n', '    function PlaceSellOrder(uint256 amount, uint256 price) public {\n', '        require(price > 0);\n', '        require(balanceOf[msg.sender] >= amount);\n', '        SellOrders[msg.sender] = [amount, price];\n', '        emit SellOrderPlaced(msg.sender, amount, price);\n', '    }\n', '\n', '    // Safe buy order where user specifies the max amount to buy and the max price; prevents snipers changing their price \n', '    function Buy(address target, uint256 maxamount, uint256 maxprice) public payable {\n', '        require(SellOrders[target][0] > 0);\n', '        require(SellOrders[target][1] <= maxprice);\n', '        uint256 price = SellOrders[target][1];\n', '        uint256 amount_buyable = (mul(msg.value, uint256(10**decimals))) / price; \n', '        \n', '        // decide how much we buy \n', '        \n', '        if (amount_buyable > SellOrders[target][0]){\n', '            amount_buyable = SellOrders[target][0];\n', '        }\n', '        if (amount_buyable > maxamount){\n', '            amount_buyable = maxamount;\n', '        }\n', '        //10000000000000000000,14999999999999\n', '        //"0xca35b7d915458ef540ade6068dfe2f44e8fa733c",10000000000000000000,14999999999999\n', '        uint256 total_payment = mul(amount_buyable, price) / (uint256(10 ** decimals));\n', '        \n', "        // Let's buy tokens and actually pay, okay?\n", '        require(amount_buyable > 0 && total_payment > 0); \n', '        \n', '        // From the amount we actually pay, we take exchange fee from it \n', '        \n', '        uint256 Fee = mul(total_payment, SellFee) / 10000;\n', '        uint256 Left = total_payment - Fee; \n', '        \n', '        uint256 Excess = msg.value - total_payment;\n', '        \n', '        uint256 OldTokensSeller = balanceOf[target];\n', '        uint256 OldTokensBuyer = balanceOf[msg.sender];\n', '\n', '        // Change it in memory \n', '        _forceTransfer(target, msg.sender, amount_buyable);\n', '        \n', '        // Pay out withdrawals and reset timer\n', '        // Prevents double withdrawals in same tx\n', '        \n', '        // Change sell order \n', '        SellOrders[target][0] = sub(SellOrders[target][0],amount_buyable);\n', '        \n', '        \n', '        // start all transfer stuff \n', '\n', '        uint256 _sendTarget = _withdraw(target, OldTokensSeller, false,0);\n', '        uint256 _sendBuyer = _withdraw(msg.sender, OldTokensBuyer, false, _sendTarget);\n', '        \n', '        // in one transfer saves gas, but its not nice in the etherscan logs \n', '        target.transfer(add(Left, _sendTarget));\n', '        \n', '        if (add(Excess, _sendBuyer) > 0){\n', '            msg.sender.transfer(add(Excess,_sendBuyer));\n', '        }\n', '        \n', '        if (Fee > 0){\n', '            owner.transfer(Fee);\n', '        }\n', '     \n', '        emit SellOrderFilled(msg.sender, target, amount_buyable,  price, Left);\n', '    }\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event SellOrderPlaced(address who, uint256 available, uint256 price);\n', '    event SellOrderFilled(address buyer, address seller, uint256 tokens, uint256 price, uint256 payment);\n', '    event SellOrderCancelled(address who);\n', '    event WithdrawalComplete(address who, uint256 got);\n', '    \n', '    \n', '    // thanks for divs \n', '    function() public payable{\n', '        \n', '    }\n', '    \n', '    // safemath \n', '    \n', '      function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
