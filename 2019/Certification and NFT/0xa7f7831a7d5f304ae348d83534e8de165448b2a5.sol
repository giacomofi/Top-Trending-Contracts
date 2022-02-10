['pragma solidity ^0.5.2;\n', '\n', 'interface ERC223Handler { \n', '    function tokenFallback(address _from, uint _value, bytes calldata _data) external;\n', '}\n', '\n', 'interface ICOStickers {\n', '    function giveSticker(address _to, uint256 _property) external;\n', '}\n', '\n', '\n', 'contract ICOToken{\n', '    using SafeMath for uint256;\n', '    using SafeMath for uint;\n', '    \n', '\tmodifier onlyOwner {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '    \n', '    constructor(address _s) public{\n', '        stickers = ICOStickers(_s);\n', '        totalSupply = 0;\n', '        owner = msg.sender;\n', '    }\n', '\taddress owner;\n', '\taddress newOwner;\n', '    \n', '    uint256 constant internal MAX_UINT256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;\n', '    uint256 constant internal TOKEN_PRICE = 0.0001 ether;\n', '    uint256 constant public fundingCap = 2000 ether;\n', '\n', '    uint256 constant public IcoStartTime = 1546628400; // Jan 04 2019 20:00:00 GMT+0100\n', '    uint256 constant public IcoEndTime = 1550084400; // Feb 13 2019 20:00:00 GMT+0100\n', '\n', '\n', '    ICOStickers internal stickers;\n', '    mapping(address => uint256) internal beneficiaryWithdrawAmount;\n', '    mapping(address => uint256) public beneficiaryShares;\n', '    uint256 public beneficiaryTotalShares;\n', '    uint256 public beneficiaryPayoutPerShare;\n', '    uint256 public icoFunding;\n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => uint256) public etherSpent;\n', '    mapping(address => mapping (address => uint256)) internal allowances;\n', '    string constant public name = "0xchan ICO";\n', '    string constant public symbol = "ZCI";\n', '    uint8 constant public decimals = 18;\n', '    uint256 public totalSupply;\n', '    \n', '    // --Events\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '    \n', '    event onICOBuy(address indexed from, uint256 tokens, uint256 bonusTokens);\n', '    // --Events--\n', '    \n', '    // --Owner only functions\n', '    function setNewOwner(address o) public onlyOwner {\n', '\t\tnewOwner = o;\n', '\t}\n', '\n', '\tfunction acceptNewOwner() public {\n', '\t\trequire(msg.sender == newOwner);\n', '\t\towner = msg.sender;\n', '\t}\n', '\t\n', '    // For the 0xchan ICO, the following beneficieries will be added.\n', '    // 3 - Aritz\n', '    // 3 - Sumpunk\n', '    // 2 - Multisig wallet for bounties/audit payments\n', '\tfunction addBeneficiary(address b, uint256 shares) public onlyOwner {\n', '\t   require(block.timestamp < IcoStartTime, "ICO has started");\n', '\t   require(beneficiaryWithdrawAmount[b] == 0, "Already a beneficiary");\n', '\t   beneficiaryWithdrawAmount[b] = MAX_UINT256;\n', '\t   beneficiaryShares[b] = shares;\n', '\t   beneficiaryTotalShares += shares;\n', '\t}\n', '\t\n', '\tfunction removeBeneficiary(address b, uint256 shares) public onlyOwner {\n', '\t   require(block.timestamp < IcoStartTime, "ICO has started");\n', '\t   require(beneficiaryWithdrawAmount[b] != 0, "Not a beneficiary");\n', '\t   delete beneficiaryWithdrawAmount[b];\n', '\t   delete beneficiaryShares[b];\n', '\t   beneficiaryTotalShares -= shares;\n', '\t}\n', '\t\n', '\t// --Owner only functions--\n', '    \n', '    // --Public write functions\n', '    function withdrawFunding(uint256 _amount) public {\n', '        if (icoFunding == 0){\n', '            require(address(this).balance >= fundingCap || block.timestamp >= IcoEndTime, "ICO hasn&#39;t ended");\n', '            icoFunding = address(this).balance;\n', '        }\n', '        require(beneficiaryWithdrawAmount[msg.sender] > 0, "You&#39;re not a beneficiary");\n', '        uint256 stash = beneficiaryStash(msg.sender);\n', '        if (_amount >= stash){\n', '            beneficiaryWithdrawAmount[msg.sender] = beneficiaryPayoutPerShare * beneficiaryShares[msg.sender];\n', '            msg.sender.transfer(stash);\n', '        }else{\n', '            if (beneficiaryWithdrawAmount[msg.sender] == MAX_UINT256){\n', '                beneficiaryWithdrawAmount[msg.sender] = _amount;\n', '            }else{\n', '                beneficiaryWithdrawAmount[msg.sender] += _amount;\n', '            }\n', '            msg.sender.transfer(_amount);\n', '        }\n', '    }\n', '    \n', '    function() payable external{\n', '        require(block.timestamp >= IcoStartTime, "ICO hasn&#39;t started yet");\n', '        require(icoFunding == 0 && block.timestamp < IcoEndTime, "ICO has ended");\n', '        require(msg.value != 0 && ((msg.value % TOKEN_PRICE) == 0), "Must be a multiple of 0.0001 ETH");\n', '        \n', '        uint256 thisBalance = address(this).balance; \n', '        uint256 msgValue = msg.value;\n', '        \n', '        // While the extra ETH is appriciated, we set ourselves a hardcap and we&#39;re gonna stick to it!\n', '        if (thisBalance > fundingCap){\n', '            msgValue -= (thisBalance - fundingCap);\n', '            require(msgValue != 0, "Funding cap has been reached");\n', '            thisBalance = fundingCap;\n', '        }\n', '        \n', '        uint256 oldBalance = thisBalance - msgValue;\n', '        uint256 tokensToGive = (msgValue / TOKEN_PRICE) * 1e18;\n', '        uint256 bonusTokens;\n', '        \n', '        uint256 difference;\n', '        \n', '        while (oldBalance < thisBalance){\n', '            if (oldBalance < 500 ether){\n', '                difference = min(500 ether, thisBalance) - oldBalance;\n', '                bonusTokens += ((difference / TOKEN_PRICE) * 1e18) / 2;\n', '                oldBalance += difference;\n', '            }else if(oldBalance < 1250 ether){\n', '                difference = min(1250 ether, thisBalance) - oldBalance;\n', '                bonusTokens += ((difference / TOKEN_PRICE) * 1e18) / 5;\n', '                oldBalance += difference;\n', '            }else{\n', '                difference = thisBalance - oldBalance;\n', '                bonusTokens += ((difference / TOKEN_PRICE) * 1e18) / 10;\n', '                oldBalance += difference;\n', '            }\n', '        }\n', '        emit onICOBuy(msg.sender, tokensToGive, bonusTokens);\n', '        \n', '        tokensToGive += bonusTokens;\n', '        balanceOf[msg.sender] += tokensToGive;\n', '        totalSupply += tokensToGive;\n', '        \n', '        if (address(stickers) != address(0)){\n', '            stickers.giveSticker(msg.sender, msgValue);\n', '        }\n', '        emit Transfer(address(this), msg.sender, tokensToGive, "");\n', '        emit Transfer(address(this), msg.sender, tokensToGive);\n', '        \n', '        beneficiaryPayoutPerShare = thisBalance / beneficiaryTotalShares;\n', '        etherSpent[msg.sender] += msgValue;\n', '        if (msgValue != msg.value){\n', '            // Finally return any extra ETH sent.\n', '            msg.sender.transfer(msg.value - msgValue); \n', '        }\n', '    }\n', '    \n', '    function transfer(address _to, uint _value, bytes memory _data, string memory _function) public returns(bool ok){\n', '        actualTransfer(msg.sender, _to, _value, _data, _function, true);\n', '        return true;\n', '    }\n', '    \n', '    function transfer(address _to, uint _value, bytes memory _data) public returns(bool ok){\n', '        actualTransfer(msg.sender, _to, _value, _data, "", true);\n', '        return true;\n', '    }\n', '    function transfer(address _to, uint _value) public returns(bool ok){\n', '        actualTransfer(msg.sender, _to, _value, "", "", true);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        uint256 _allowance = allowances[_from][msg.sender];\n', '        require(_allowance > 0, "Not approved");\n', '        require(_allowance >= _value, "Over spending limit");\n', '        allowances[_from][msg.sender] = _allowance.sub(_value);\n', '        actualTransfer(_from, _to, _value, "", "", false);\n', '        return true;\n', '    }\n', '    \n', '    // --Public write functions--\n', '     \n', '    // --Public read-only functions\n', '    function beneficiaryStash(address b) public view returns (uint256){\n', '        uint256 withdrawAmount = beneficiaryWithdrawAmount[b];\n', '        if (withdrawAmount == 0){\n', '            return 0;\n', '        }\n', '        if (withdrawAmount == MAX_UINT256){\n', '            return beneficiaryPayoutPerShare * beneficiaryShares[b];\n', '        }\n', '        return (beneficiaryPayoutPerShare * beneficiaryShares[b]) - withdrawAmount;\n', '    }\n', '    \n', '    function allowance(address _sugardaddy, address _spender) public view returns (uint remaining) {\n', '        return allowances[_sugardaddy][_spender];\n', '    }\n', '    \n', '    // --Public read-only functions--\n', '    \n', '    \n', '    \n', '    // Internal functions\n', '    \n', '    function actualTransfer (address _from, address _to, uint _value, bytes memory _data, string memory _function, bool _careAboutHumanity) private {\n', '        // You can only transfer this token after the ICO has ended.\n', '        require(icoFunding != 0 || address(this).balance >= fundingCap || block.timestamp >= IcoEndTime, "ICO hasn&#39;t ended");\n', '        require(balanceOf[_from] >= _value, "Insufficient balance");\n', '        require(_to != address(this), "You can&#39;t sell back your tokens");\n', '        \n', '        // Throwing an exception undos all changes. Otherwise changing the balance now would be a shitshow\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        \n', '        if(_careAboutHumanity && isContract(_to)) {\n', '            if (bytes(_function).length == 0){\n', '                ERC223Handler receiver = ERC223Handler(_to);\n', '                receiver.tokenFallback(_from, _value, _data);\n', '            }else{\n', '                bool success;\n', '                bytes memory returnData;\n', '                (success, returnData) = _to.call.value(0)(abi.encodeWithSignature(_function, _from, _value, _data));\n', '                assert(success);\n', '            }\n', '        }\n', '        emit Transfer(_from, _to, _value, _data);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '    \n', '    function min(uint256 i1, uint256 i2) private pure returns (uint256) {\n', '        if (i1 < i2){\n', '            return i1;\n', '        }\n', '        return i2;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0 || b == 0) {\n', '           return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '    \n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']