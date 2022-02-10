['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract XRRtoken {\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract XRRsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    XRRtoken public token;\n', '    address public wallet;\n', '\n', '    uint256 public totalRaiseWei = 0;\n', '    uint256 public totalTokenRaiseWei = 0;\n', '\n', '    // Only for TestNet\n', '    //    uint PreSaleStart = now;\n', '\n', '    // Pre-Sale Launch March 20 - April 5th\n', '    uint PreSaleStart = 1521504000;\n', '\n', '    uint PreSaleEnd = 1522886400;\n', '\n', '\n', '    //  Crowd sale Launch 12th - May 9th\n', '    uint ICO1 = 1523491200;\n', '    uint ICO2 = 1524096000;\n', '    uint ICO3 = 1524700800;\n', '    uint ICO4 = 1525305600;\n', '    uint ICOend = 1525910400;\n', '\n', '    function XRRsale() public {\n', '        wallet = msg.sender;\n', '    }\n', '\n', '    function setToken(XRRtoken _token) public {\n', '        token = _token;\n', '    }\n', '\n', '    function setWallet(address _wallet) public {\n', '        wallet = _wallet;\n', '    }\n', '\n', '\n', '    function currentPrice() public view returns (uint256){\n', '        if (now > PreSaleStart && now < PreSaleEnd) return 26000;\n', '        else if (now > ICO1 && now < ICO2) return 12000;\n', '        else if (now > ICO2 && now < ICO3) return 11500;\n', '        else if (now > ICO3 && now < ICO4) return 11000;\n', '        else if (now > ICO4 && now < ICOend) return 10500;\n', '        else return 0;\n', '    }\n', '\n', '\n', '    function checkAmount(uint256 _amount) public view returns (bool){\n', '        if (now > PreSaleStart && now < PreSaleEnd) return _amount >= 1 ether;\n', '        else if (now > ICO1 && now < ICO2) return _amount >= 0.1 ether;\n', '        else if (now > ICO2 && now < ICO3) return _amount >= 0.1 ether;\n', '        else if (now > ICO3 && now < ICO4) return _amount >= 0.1 ether;\n', '        else if (now > ICO4 && now < ICOend) return _amount >= 0.1 ether;\n', '        else return false;\n', '    }\n', '\n', '\n', '    function tokenTosale() public view returns (uint256){\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    function tokenWithdraw() public onlyOwner {\n', '        require(tokenTosale() > 0);\n', '        token.transfer(owner, tokenTosale());\n', '    }\n', '\n', '    function() public payable {\n', '        require(msg.value > 0);\n', '        require(checkAmount(msg.value));\n', '        require(currentPrice() > 0);\n', '\n', '        totalRaiseWei = totalRaiseWei.add(msg.value);\n', '        uint256 tokens = currentPrice().mul(msg.value);\n', '        require(tokens <= tokenTosale());\n', '\n', '        totalTokenRaiseWei = totalTokenRaiseWei.add(tokens);\n', '        token.transfer(msg.sender, tokens);\n', '    }\n', '\n', '    function sendTokens(address _to, uint256 _value) public onlyOwner {\n', '        require(_value > 0);\n', '        require(_value <= tokenTosale());\n', '        require(currentPrice() > 0);\n', '\n', '        uint256 amount = _value.div(currentPrice());\n', '        totalRaiseWei = totalRaiseWei.add(amount);\n', '        totalTokenRaiseWei = totalTokenRaiseWei.add(_value);\n', '        token.transfer(_to, _value);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract XRRtoken {\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract XRRsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    XRRtoken public token;\n', '    address public wallet;\n', '\n', '    uint256 public totalRaiseWei = 0;\n', '    uint256 public totalTokenRaiseWei = 0;\n', '\n', '    // Only for TestNet\n', '    //    uint PreSaleStart = now;\n', '\n', '    // Pre-Sale Launch March 20 - April 5th\n', '    uint PreSaleStart = 1521504000;\n', '\n', '    uint PreSaleEnd = 1522886400;\n', '\n', '\n', '    //  Crowd sale Launch 12th - May 9th\n', '    uint ICO1 = 1523491200;\n', '    uint ICO2 = 1524096000;\n', '    uint ICO3 = 1524700800;\n', '    uint ICO4 = 1525305600;\n', '    uint ICOend = 1525910400;\n', '\n', '    function XRRsale() public {\n', '        wallet = msg.sender;\n', '    }\n', '\n', '    function setToken(XRRtoken _token) public {\n', '        token = _token;\n', '    }\n', '\n', '    function setWallet(address _wallet) public {\n', '        wallet = _wallet;\n', '    }\n', '\n', '\n', '    function currentPrice() public view returns (uint256){\n', '        if (now > PreSaleStart && now < PreSaleEnd) return 26000;\n', '        else if (now > ICO1 && now < ICO2) return 12000;\n', '        else if (now > ICO2 && now < ICO3) return 11500;\n', '        else if (now > ICO3 && now < ICO4) return 11000;\n', '        else if (now > ICO4 && now < ICOend) return 10500;\n', '        else return 0;\n', '    }\n', '\n', '\n', '    function checkAmount(uint256 _amount) public view returns (bool){\n', '        if (now > PreSaleStart && now < PreSaleEnd) return _amount >= 1 ether;\n', '        else if (now > ICO1 && now < ICO2) return _amount >= 0.1 ether;\n', '        else if (now > ICO2 && now < ICO3) return _amount >= 0.1 ether;\n', '        else if (now > ICO3 && now < ICO4) return _amount >= 0.1 ether;\n', '        else if (now > ICO4 && now < ICOend) return _amount >= 0.1 ether;\n', '        else return false;\n', '    }\n', '\n', '\n', '    function tokenTosale() public view returns (uint256){\n', '        return token.balanceOf(this);\n', '    }\n', '\n', '    function tokenWithdraw() public onlyOwner {\n', '        require(tokenTosale() > 0);\n', '        token.transfer(owner, tokenTosale());\n', '    }\n', '\n', '    function() public payable {\n', '        require(msg.value > 0);\n', '        require(checkAmount(msg.value));\n', '        require(currentPrice() > 0);\n', '\n', '        totalRaiseWei = totalRaiseWei.add(msg.value);\n', '        uint256 tokens = currentPrice().mul(msg.value);\n', '        require(tokens <= tokenTosale());\n', '\n', '        totalTokenRaiseWei = totalTokenRaiseWei.add(tokens);\n', '        token.transfer(msg.sender, tokens);\n', '    }\n', '\n', '    function sendTokens(address _to, uint256 _value) public onlyOwner {\n', '        require(_value > 0);\n', '        require(_value <= tokenTosale());\n', '        require(currentPrice() > 0);\n', '\n', '        uint256 amount = _value.div(currentPrice());\n', '        totalRaiseWei = totalRaiseWei.add(amount);\n', '        totalTokenRaiseWei = totalTokenRaiseWei.add(_value);\n', '        token.transfer(_to, _value);\n', '    }\n', '}']
