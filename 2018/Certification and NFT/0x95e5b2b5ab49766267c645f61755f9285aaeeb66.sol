['pragma solidity ^0.4.17;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Token {\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract GroupBuy {\n', '    using SafeMath for uint256;\n', '\n', '    enum Phase { Init, Contribute, Wait, Claim, Lock }\n', '    uint256 private constant MAX_TOTAL = 500 ether;\n', '    uint256 private constant MAX_EACH = 2 ether;\n', '\n', '    address private tokenAddr;\n', '    address private owner;\n', '    mapping(address => uint256) private amounts;\n', '    uint256 private totalEth;\n', '    uint256 private totalToken;\n', '    Phase private currentPhase;\n', '\n', '    function GroupBuy() public {\n', '        owner = msg.sender;\n', '        currentPhase = Phase.Init;\n', '    }\n', '\n', '    modifier isOwner() {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // admin function\n', '    function beginContrib() isOwner public {\n', '        require(currentPhase == Phase.Init || currentPhase == Phase.Wait);\n', '        currentPhase = Phase.Contribute;\n', '    }\n', '\n', '    function endContrib() isOwner public {\n', '        require(currentPhase == Phase.Contribute);\n', '        currentPhase = Phase.Wait;\n', '        owner.transfer(address(this).balance); // collect eth to buy token\n', '    }\n', '\n', '    function allowClaim(address _addr) isOwner public returns (uint256) {\n', '        require(currentPhase == Phase.Wait);\n', '        currentPhase = Phase.Claim;\n', '        tokenAddr = _addr;\n', '        \n', '        ERC20Token tok = ERC20Token(tokenAddr);\n', '        totalToken = tok.balanceOf(this);\n', '        require(totalToken > 0);\n', '        return totalToken;\n', '    }\n', '\n', '    // rescue function\n', '    function lock() isOwner public {\n', '        require(currentPhase == Phase.Claim);\n', '        currentPhase = Phase.Lock;\n', '    }\n', '\n', '    function unlock() isOwner public {\n', '        require(currentPhase == Phase.Lock);\n', '        currentPhase = Phase.Claim;\n', '    }\n', '\n', '    function collectEth() isOwner public {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    function setTotalToken(uint _total) isOwner public {\n', '        require(_total > 0);\n', '        totalToken = _total;\n', '    }\n', '\n', '    function setTokenAddr(address _addr) isOwner public {\n', '        tokenAddr = _addr;\n', '    }\n', '\n', '    function withdrawToken(address _erc20, uint _amount) isOwner public returns (bool success) {\n', '        return ERC20Token(_erc20).transfer(owner, _amount);\n', '    } \n', '\n', '    // user function\n', '    function() public payable {\n', '        revert();\n', '    }\n', '\n', '    function info() public view returns (uint phase, uint userEth, uint userToken, uint allEth, uint allToken) {\n', '        phase = uint(currentPhase);\n', '        userEth = amounts[msg.sender];\n', '        userToken = totalEth > 0 ? totalToken.mul(userEth).div(totalEth) : 0;\n', '        allEth = totalEth;\n', '        allToken = totalToken;\n', '    }\n', '\n', '    function contribute() public payable returns (uint _value) {\n', '        require(msg.value > 0);\n', '        require(currentPhase == Phase.Contribute);\n', '        uint cur = amounts[msg.sender];\n', '        require(cur < MAX_EACH && totalEth < MAX_TOTAL);\n', '\n', '        _value = msg.value > MAX_EACH.sub(cur) ? MAX_EACH.sub(cur) : msg.value;\n', '        _value = _value > MAX_TOTAL.sub(totalEth) ? MAX_TOTAL.sub(totalEth) : _value;\n', '        amounts[msg.sender] = cur.add(_value);\n', '        totalEth = totalEth.add(_value);\n', '\n', '        // return redundant eth to user\n', '        if (msg.value.sub(_value) > 0) {\n', '            msg.sender.transfer(msg.value.sub(_value));\n', '        }\n', '    }\n', '\n', '    function claim() public returns (uint amountToken) {\n', '        require(currentPhase == Phase.Claim);\n', '        uint contributed = amounts[msg.sender];\n', '        amountToken = totalEth > 0 ? totalToken.mul(contributed).div(totalEth) : 0;\n', '\n', '        require(amountToken > 0);\n', '        require(ERC20Token(tokenAddr).transfer(msg.sender, amountToken));\n', '        amounts[msg.sender] = 0;\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Token {\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract GroupBuy {\n', '    using SafeMath for uint256;\n', '\n', '    enum Phase { Init, Contribute, Wait, Claim, Lock }\n', '    uint256 private constant MAX_TOTAL = 500 ether;\n', '    uint256 private constant MAX_EACH = 2 ether;\n', '\n', '    address private tokenAddr;\n', '    address private owner;\n', '    mapping(address => uint256) private amounts;\n', '    uint256 private totalEth;\n', '    uint256 private totalToken;\n', '    Phase private currentPhase;\n', '\n', '    function GroupBuy() public {\n', '        owner = msg.sender;\n', '        currentPhase = Phase.Init;\n', '    }\n', '\n', '    modifier isOwner() {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // admin function\n', '    function beginContrib() isOwner public {\n', '        require(currentPhase == Phase.Init || currentPhase == Phase.Wait);\n', '        currentPhase = Phase.Contribute;\n', '    }\n', '\n', '    function endContrib() isOwner public {\n', '        require(currentPhase == Phase.Contribute);\n', '        currentPhase = Phase.Wait;\n', '        owner.transfer(address(this).balance); // collect eth to buy token\n', '    }\n', '\n', '    function allowClaim(address _addr) isOwner public returns (uint256) {\n', '        require(currentPhase == Phase.Wait);\n', '        currentPhase = Phase.Claim;\n', '        tokenAddr = _addr;\n', '        \n', '        ERC20Token tok = ERC20Token(tokenAddr);\n', '        totalToken = tok.balanceOf(this);\n', '        require(totalToken > 0);\n', '        return totalToken;\n', '    }\n', '\n', '    // rescue function\n', '    function lock() isOwner public {\n', '        require(currentPhase == Phase.Claim);\n', '        currentPhase = Phase.Lock;\n', '    }\n', '\n', '    function unlock() isOwner public {\n', '        require(currentPhase == Phase.Lock);\n', '        currentPhase = Phase.Claim;\n', '    }\n', '\n', '    function collectEth() isOwner public {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    function setTotalToken(uint _total) isOwner public {\n', '        require(_total > 0);\n', '        totalToken = _total;\n', '    }\n', '\n', '    function setTokenAddr(address _addr) isOwner public {\n', '        tokenAddr = _addr;\n', '    }\n', '\n', '    function withdrawToken(address _erc20, uint _amount) isOwner public returns (bool success) {\n', '        return ERC20Token(_erc20).transfer(owner, _amount);\n', '    } \n', '\n', '    // user function\n', '    function() public payable {\n', '        revert();\n', '    }\n', '\n', '    function info() public view returns (uint phase, uint userEth, uint userToken, uint allEth, uint allToken) {\n', '        phase = uint(currentPhase);\n', '        userEth = amounts[msg.sender];\n', '        userToken = totalEth > 0 ? totalToken.mul(userEth).div(totalEth) : 0;\n', '        allEth = totalEth;\n', '        allToken = totalToken;\n', '    }\n', '\n', '    function contribute() public payable returns (uint _value) {\n', '        require(msg.value > 0);\n', '        require(currentPhase == Phase.Contribute);\n', '        uint cur = amounts[msg.sender];\n', '        require(cur < MAX_EACH && totalEth < MAX_TOTAL);\n', '\n', '        _value = msg.value > MAX_EACH.sub(cur) ? MAX_EACH.sub(cur) : msg.value;\n', '        _value = _value > MAX_TOTAL.sub(totalEth) ? MAX_TOTAL.sub(totalEth) : _value;\n', '        amounts[msg.sender] = cur.add(_value);\n', '        totalEth = totalEth.add(_value);\n', '\n', '        // return redundant eth to user\n', '        if (msg.value.sub(_value) > 0) {\n', '            msg.sender.transfer(msg.value.sub(_value));\n', '        }\n', '    }\n', '\n', '    function claim() public returns (uint amountToken) {\n', '        require(currentPhase == Phase.Claim);\n', '        uint contributed = amounts[msg.sender];\n', '        amountToken = totalEth > 0 ? totalToken.mul(contributed).div(totalEth) : 0;\n', '\n', '        require(amountToken > 0);\n', '        require(ERC20Token(tokenAddr).transfer(msg.sender, amountToken));\n', '        amounts[msg.sender] = 0;\n', '    }\n', '}']
