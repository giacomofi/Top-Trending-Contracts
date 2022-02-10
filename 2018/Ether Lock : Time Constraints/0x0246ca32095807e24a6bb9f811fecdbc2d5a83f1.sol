['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  \n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() internal {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract tokenInterface {\n', '\tfunction balanceOf(address _owner) public constant returns (uint256 balance);\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract rateInterface {\n', '    function readRate(string _currency) public view returns (uint256 oneEtherValue);\n', '}\n', '\n', 'contract ICOEngineInterface {\n', '\n', '    // false if the ico is not started, true if the ico is started and running, true if the ico is completed\n', '    function started() public view returns(bool);\n', '\n', '    // false if the ico is not started, false if the ico is started and running, true if the ico is completed\n', '    function ended() public view returns(bool);\n', '\n', '    // time stamp of the starting time of the ico, must return 0 if it depends on the block number\n', '    function startTime() public view returns(uint);\n', '\n', '    // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number\n', '    function endTime() public view returns(uint);\n', '\n', '    // Optional function, can be implemented in place of startTime\n', '    // Returns the starting block number of the ico, must return 0 if it depends on the time stamp\n', '    // function startBlock() public view returns(uint);\n', '\n', '    // Optional function, can be implemented in place of endTime\n', '    // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp\n', '    // function endBlock() public view returns(uint);\n', '\n', '    // returns the total number of the tokens available for the sale, must not change when the ico is started\n', '    function totalTokens() public view returns(uint);\n', '\n', '    // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),\n', '    // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()\n', '    function remainingTokens() public view returns(uint);\n', '\n', '    // return the price as number of tokens released for each ether\n', '    function price() public view returns(uint);\n', '}\n', '\n', 'contract KYCBase {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => bool) public isKycSigner;\n', '    mapping (uint64 => uint256) public alreadyPayed;\n', '\n', '    event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);\n', '\n', '    function KYCBase(address [] kycSigners) internal {\n', '        for (uint i = 0; i < kycSigners.length; i++) {\n', '            isKycSigner[kycSigners[i]] = true;\n', '        }\n', '    }\n', '\n', '    // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed\n', '    function releaseTokensTo(address buyer) internal returns(bool);\n', '\n', '    // This method can be overridden to enable some sender to buy token for a different address\n', '    function senderAllowedFor(address buyer)\n', '        internal view returns(bool)\n', '    {\n', '        return buyer == msg.sender;\n', '    }\n', '\n', '    function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)\n', '        public payable returns (bool)\n', '    {\n', '        require(senderAllowedFor(buyerAddress));\n', '        return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);\n', '    }\n', '\n', '    function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)\n', '        public payable returns (bool)\n', '    {\n', '        return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);\n', '    }\n', '\n', '    function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)\n', '        private returns (bool)\n', '    {\n', '        // check the signature\n', '        bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount); \n', '        address signer = ecrecover(hash, v, r, s);\n', '        if (!isKycSigner[signer]) {\n', '            revert();\n', '        } else {\n', '            uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);\n', '            require(totalPayed <= maxAmount);\n', '            alreadyPayed[buyerId] = totalPayed;\n', '            emit KycVerified(signer, buyerAddress, buyerId, maxAmount);\n', '            return releaseTokensTo(buyerAddress);\n', '        }\n', '    }\n', '}\n', '\n', 'contract RC is ICOEngineInterface, KYCBase {\n', '    using SafeMath for uint256;\n', '    TokenSale tokenSaleContract;\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '    \n', '    uint256 public etherMinimum;\n', '    uint256 public soldTokens;\n', '    uint256 public remainingTokens;\n', '    \n', '    uint256 public oneTokenInFiatWei;\n', '\t\n', '\t\n', '\tmapping(address => uint256) public etherUser; // address => ether amount\n', '\tmapping(address => uint256) public pendingTokenUser; // address => token amount that will be claimed\n', '\tmapping(address => uint256) public tokenUser; // address => token amount owned\n', '\tuint256[] public tokenThreshold; // array of token threshold reached in wei of token\n', '    uint256[] public bonusThreshold; // array of bonus of each tokenThreshold reached - 20% = 20\n', '\n', '    function RC(address _tokenSaleContract, uint256 _oneTokenInFiatWei, uint256 _remainingTokens, uint256 _etherMinimum, uint256 _startTime , uint256 _endTime, address [] kycSigner, uint256[] _tokenThreshold, uint256[] _bonusThreshold ) public KYCBase(kycSigner) {\n', '        require ( _tokenSaleContract != 0 );\n', '        require ( _oneTokenInFiatWei != 0 );\n', '        require( _remainingTokens != 0 );\n', '        require ( _tokenThreshold.length != 0 );\n', '        require ( _tokenThreshold.length == _bonusThreshold.length );\n', '        bonusThreshold = _bonusThreshold;\n', '        tokenThreshold = _tokenThreshold;\n', '        \n', '        \n', '        tokenSaleContract = TokenSale(_tokenSaleContract);\n', '        \n', '        tokenSaleContract.addMeByRC();\n', '        \n', '        soldTokens = 0;\n', '        remainingTokens = _remainingTokens;\n', '        oneTokenInFiatWei = _oneTokenInFiatWei;\n', '        etherMinimum = _etherMinimum;\n', '        \n', '        setTimeRC( _startTime, _endTime );\n', '    }\n', '    \n', '    function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {\n', '        if( _startTime == 0 ) {\n', '            startTime = tokenSaleContract.startTime();\n', '        } else {\n', '            startTime = _startTime;\n', '        }\n', '        if( _endTime == 0 ) {\n', '            endTime = tokenSaleContract.endTime();\n', '        } else {\n', '            endTime = _endTime;\n', '        }\n', '    }\n', '    \n', '    modifier onlyTokenSaleOwner() {\n', '        require(msg.sender == tokenSaleContract.owner() );\n', '        _;\n', '    }\n', '    \n', '    function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {\n', '        if ( _newStart != 0 ) startTime = _newStart;\n', '        if ( _newEnd != 0 ) endTime = _newEnd;\n', '    }\n', '    \n', '    function changeMinimum(uint256 _newEtherMinimum) public onlyTokenSaleOwner {\n', '        etherMinimum = _newEtherMinimum;\n', '    }\n', '    \n', '    function releaseTokensTo(address buyer) internal returns(bool) {\n', '        if( msg.value > 0 ) takeEther(buyer);\n', '        giveToken(buyer);\n', '        return true;\n', '    }\n', '    \n', '    function started() public view returns(bool) {\n', '        return now > startTime || remainingTokens == 0;\n', '    }\n', '    \n', '    function ended() public view returns(bool) {\n', '        return now > endTime || remainingTokens == 0;\n', '    }\n', '    \n', '    function startTime() public view returns(uint) {\n', '        return startTime;\n', '    }\n', '    \n', '    function endTime() public view returns(uint) {\n', '        return endTime;\n', '    }\n', '    \n', '    function totalTokens() public view returns(uint) {\n', '        return remainingTokens.add(soldTokens);\n', '    }\n', '    \n', '    function remainingTokens() public view returns(uint) {\n', '        return remainingTokens;\n', '    }\n', '    \n', '    function price() public view returns(uint) {\n', '        uint256 oneEther = 10**18;\n', '        return oneEther.mul(10**18).div( tokenSaleContract.tokenValueInEther(oneTokenInFiatWei) );\n', '    }\n', '\t\n', '\tfunction () public payable{\n', '\t    require( now > startTime );\n', '\t    if(now < endTime) {\n', '\t        takeEther(msg.sender);\n', '\t    } else {\n', '\t        claimTokenBonus(msg.sender);\n', '\t    }\n', '\n', '\t}\n', '\t\n', '\tevent Buy(address buyer, uint256 value, uint256 soldToken, uint256 valueTokenInUsdWei );\n', '\t\n', '\tfunction takeEther(address _buyer) internal {\n', '\t    require( now > startTime );\n', '        require( now < endTime );\n', '        require( msg.value >= etherMinimum); \n', '        require( remainingTokens > 0 );\n', '        \n', '        uint256 oneToken = 10 ** uint256(tokenSaleContract.decimals());\n', '        uint256 tokenValue = tokenSaleContract.tokenValueInEther(oneTokenInFiatWei);\n', '        uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);\n', '        \n', '        uint256 unboughtTokens = tokenInterface(tokenSaleContract.tokenContract()).balanceOf(tokenSaleContract);\n', '        if ( unboughtTokens > remainingTokens ) {\n', '            unboughtTokens = remainingTokens;\n', '        }\n', '        \n', '        uint256 refund = 0;\n', '        if ( unboughtTokens < tokenAmount ) {\n', '            refund = (tokenAmount - unboughtTokens).mul(tokenValue).div(oneToken);\n', '            tokenAmount = unboughtTokens;\n', '\t\t\tremainingTokens = 0; // set remaining token to 0\n', '            _buyer.transfer(refund);\n', '        } else {\n', '\t\t\tremainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus\n', '        }\n', '        \n', '        etherUser[_buyer] = etherUser[_buyer].add(msg.value.sub(refund));\n', '        pendingTokenUser[_buyer] = pendingTokenUser[_buyer].add(tokenAmount);\t\n', '        \n', '        emit Buy( _buyer, msg.value, tokenAmount, oneTokenInFiatWei );\n', '\t}\n', '\t\n', '\tfunction giveToken(address _buyer) internal {\n', '\t    require( pendingTokenUser[_buyer] > 0 );\n', '\n', '\t\ttokenUser[_buyer] = tokenUser[_buyer].add(pendingTokenUser[_buyer]);\n', '\t\n', '\t\ttokenSaleContract.claim(_buyer, pendingTokenUser[_buyer]);\n', '\t\tsoldTokens = soldTokens.add(pendingTokenUser[_buyer]);\n', '\t\tpendingTokenUser[_buyer] = 0;\n', '\t\t\n', '\t\ttokenSaleContract.wallet().transfer(etherUser[_buyer]);\n', '\t\tetherUser[_buyer] = 0;\n', '\t}\n', '\n', '    function claimTokenBonus(address _buyer) internal {\n', '        require( now > endTime );\n', '        require( tokenUser[_buyer] > 0 );\n', '        uint256 bonusApplied = 0;\n', '        for (uint i = 0; i < tokenThreshold.length; i++) {\n', '            if ( soldTokens > tokenThreshold[i] ) {\n', '                bonusApplied = bonusThreshold[i];\n', '\t\t\t}\n', '\t\t}    \n', '\t\trequire( bonusApplied > 0 );\n', '\t\t\n', '\t\tuint256 addTokenAmount = tokenUser[_buyer].mul( bonusApplied ).div(10**2);\n', '\t\ttokenUser[_buyer] = 0; \n', '\t\t\n', '\t\ttokenSaleContract.claim(_buyer, addTokenAmount);\n', '\t\t_buyer.transfer(msg.value);\n', '    }\n', '    \n', '    function refundEther(address to) public onlyTokenSaleOwner {\n', '        to.transfer(etherUser[to]);\n', '        etherUser[to] = 0;\n', '        pendingTokenUser[to] = 0;\n', '    }\n', '    \n', '    function withdraw(address to, uint256 value) public onlyTokenSaleOwner { \n', '        to.transfer(value);\n', '    }\n', '\t\n', '\tfunction userBalance(address _user) public view returns( uint256 _pendingTokenUser, uint256 _tokenUser, uint256 _etherUser ) {\n', '\t\treturn (pendingTokenUser[_user], tokenUser[_user], etherUser[_user]);\n', '\t}\n', '}\n', '\n', 'contract RCpro is ICOEngineInterface, KYCBase {\n', '    using SafeMath for uint256;\n', '    TokenSale tokenSaleContract;\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '    \n', '    uint256 public etherMinimum;\n', '    uint256 public soldTokens;\n', '    uint256 public remainingTokens;\n', '    \n', '    uint256[] public oneTokenInFiatWei;\n', '    uint256[] public sendThreshold;\n', '\t\n', '\t\n', '\tmapping(address => uint256) public etherUser; // address => ether amount\n', '\tmapping(address => uint256) public pendingTokenUser; // address => token amount that will be claimed\n', '\tmapping(address => uint256) public tokenUser; // address => token amount owned\n', '\tuint256[] public tokenThreshold; // array of token threshold reached in wei of token\n', '    uint256[] public bonusThreshold; // array of bonus of each tokenThreshold reached - 20% = 20\n', '\n', '    function RCpro(address _tokenSaleContract, uint256[] _oneTokenInFiatWei, uint256[] _sendThreshold, uint256 _remainingTokens, uint256 _etherMinimum, uint256 _startTime , uint256 _endTime, address [] kycSigner, uint256[] _tokenThreshold, uint256[] _bonusThreshold ) public KYCBase(kycSigner) {\n', '        require ( _tokenSaleContract != 0 );\n', '        require ( _oneTokenInFiatWei[0] != 0 );\n', '        require ( _oneTokenInFiatWei.length == _sendThreshold.length );\n', '        require( _remainingTokens != 0 );\n', '        require ( _tokenThreshold.length != 0 );\n', '        require ( _tokenThreshold.length == _bonusThreshold.length );\n', '        bonusThreshold = _bonusThreshold;\n', '        tokenThreshold = _tokenThreshold;\n', '        \n', '        \n', '        tokenSaleContract = TokenSale(_tokenSaleContract);\n', '        \n', '        tokenSaleContract.addMeByRC();\n', '        \n', '        soldTokens = 0;\n', '        remainingTokens = _remainingTokens;\n', '        oneTokenInFiatWei = _oneTokenInFiatWei;\n', '        sendThreshold = _sendThreshold;\n', '        etherMinimum = _etherMinimum;\n', '        \n', '        setTimeRC( _startTime, _endTime );\n', '    }\n', '    \n', '    function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {\n', '        if( _startTime == 0 ) {\n', '            startTime = tokenSaleContract.startTime();\n', '        } else {\n', '            startTime = _startTime;\n', '        }\n', '        if( _endTime == 0 ) {\n', '            endTime = tokenSaleContract.endTime();\n', '        } else {\n', '            endTime = _endTime;\n', '        }\n', '    }\n', '    \n', '    modifier onlyTokenSaleOwner() {\n', '        require(msg.sender == tokenSaleContract.owner() );\n', '        _;\n', '    }\n', '    \n', '    function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {\n', '        if ( _newStart != 0 ) startTime = _newStart;\n', '        if ( _newEnd != 0 ) endTime = _newEnd;\n', '    }\n', '    \n', '    function changeMinimum(uint256 _newEtherMinimum) public onlyTokenSaleOwner {\n', '        etherMinimum = _newEtherMinimum;\n', '    }\n', '    \n', '    function releaseTokensTo(address buyer) internal returns(bool) {\n', '        if( msg.value > 0 ) takeEther(buyer);\n', '        giveToken(buyer);\n', '        return true;\n', '    }\n', '    \n', '    function started() public view returns(bool) {\n', '        return now > startTime || remainingTokens == 0;\n', '    }\n', '    \n', '    function ended() public view returns(bool) {\n', '        return now > endTime || remainingTokens == 0;\n', '    }\n', '    \n', '    function startTime() public view returns(uint) {\n', '        return startTime;\n', '    }\n', '    \n', '    function endTime() public view returns(uint) {\n', '        return endTime;\n', '    }\n', '    \n', '    function totalTokens() public view returns(uint) {\n', '        return remainingTokens.add(soldTokens);\n', '    }\n', '    \n', '    function remainingTokens() public view returns(uint) {\n', '        return remainingTokens;\n', '    }\n', '    \n', '    function price() public view returns(uint) {\n', '        uint256 oneEther = 10**18;\n', '        return oneEther.mul(10**18).div( tokenSaleContract.tokenValueInEther(oneTokenInFiatWei[0]) );\n', '    }\n', '\t\n', '\tfunction () public payable{\n', '\t    require( now > startTime );\n', '\t    if(now < endTime) {\n', '\t        takeEther(msg.sender);\n', '\t    } else {\n', '\t        claimTokenBonus(msg.sender);\n', '\t    }\n', '\n', '\t}\n', '\t\n', '\tevent Buy(address buyer, uint256 value, uint256 soldToken, uint256 valueTokenInFiatWei );\n', '\t\n', '\tfunction takeEther(address _buyer) internal {\n', '\t    require( now > startTime );\n', '        require( now < endTime );\n', '        require( msg.value >= etherMinimum); \n', '        require( remainingTokens > 0 );\n', '        \n', '        uint256 oneToken = 10 ** uint256(tokenSaleContract.decimals());\n', '\t\t\n', '\t\tuint256 tknPriceApplied = 0;\n', '        for (uint i = 0; i < sendThreshold.length; i++) {\n', '            if ( msg.value >= sendThreshold[i] ) {\n', '                tknPriceApplied = oneTokenInFiatWei[i];\n', '\t\t\t}\n', '\t\t}    \n', '\t\trequire( tknPriceApplied > 0 );\n', '\t\t\n', '        uint256 tokenValue = tokenSaleContract.tokenValueInEther(tknPriceApplied);\n', '        uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);\n', '        \n', '        uint256 unboughtTokens = tokenInterface(tokenSaleContract.tokenContract()).balanceOf(tokenSaleContract);\n', '        if ( unboughtTokens > remainingTokens ) {\n', '            unboughtTokens = remainingTokens;\n', '        }\n', '        \n', '        uint256 refund = 0;\n', '        if ( unboughtTokens < tokenAmount ) {\n', '            refund = (tokenAmount - unboughtTokens).mul(tokenValue).div(oneToken);\n', '            tokenAmount = unboughtTokens;\n', '\t\t\tremainingTokens = 0; // set remaining token to 0\n', '            _buyer.transfer(refund);\n', '        } else {\n', '\t\t\tremainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus\n', '        }\n', '        \n', '        etherUser[_buyer] = etherUser[_buyer].add(msg.value.sub(refund));\n', '        pendingTokenUser[_buyer] = pendingTokenUser[_buyer].add(tokenAmount);\t\n', '        \n', '        emit Buy( _buyer, msg.value, tokenAmount, tknPriceApplied );\n', '\t}\n', '\t\n', '\tfunction giveToken(address _buyer) internal {\n', '\t    require( pendingTokenUser[_buyer] > 0 );\n', '\n', '\t\ttokenUser[_buyer] = tokenUser[_buyer].add(pendingTokenUser[_buyer]);\n', '\t\n', '\t\ttokenSaleContract.claim(_buyer, pendingTokenUser[_buyer]);\n', '\t\tsoldTokens = soldTokens.add(pendingTokenUser[_buyer]);\n', '\t\tpendingTokenUser[_buyer] = 0;\n', '\t\t\n', '\t\ttokenSaleContract.wallet().transfer(etherUser[_buyer]);\n', '\t\tetherUser[_buyer] = 0;\n', '\t}\n', '\n', '    function claimTokenBonus(address _buyer) internal {\n', '        require( now > endTime );\n', '        require( tokenUser[_buyer] > 0 );\n', '        uint256 bonusApplied = 0;\n', '        for (uint i = 0; i < tokenThreshold.length; i++) {\n', '            if ( soldTokens > tokenThreshold[i] ) {\n', '                bonusApplied = bonusThreshold[i];\n', '\t\t\t}\n', '\t\t}    \n', '\t\trequire( bonusApplied > 0 );\n', '\t\t\n', '\t\tuint256 addTokenAmount = tokenUser[_buyer].mul( bonusApplied ).div(10**2);\n', '\t\ttokenUser[_buyer] = 0; \n', '\t\t\n', '\t\ttokenSaleContract.claim(_buyer, addTokenAmount);\n', '\t\t_buyer.transfer(msg.value);\n', '    }\n', '    \n', '    function refundEther(address to) public onlyTokenSaleOwner {\n', '        to.transfer(etherUser[to]);\n', '        etherUser[to] = 0;\n', '        pendingTokenUser[to] = 0;\n', '    }\n', '    \n', '    function withdraw(address to, uint256 value) public onlyTokenSaleOwner { \n', '        to.transfer(value);\n', '    }\n', '\t\n', '\tfunction userBalance(address _user) public view returns( uint256 _pendingTokenUser, uint256 _tokenUser, uint256 _etherUser ) {\n', '\t\treturn (pendingTokenUser[_user], tokenUser[_user], etherUser[_user]);\n', '\t}\n', '}\n', '\n', 'contract TokenSale is Ownable {\n', '    using SafeMath for uint256;\n', '    tokenInterface public tokenContract;\n', '    rateInterface public rateContract;\n', '    \n', '    address public wallet;\n', '    address public advisor;\n', '    uint256 public advisorFee; // 1 = 0,1%\n', '    \n', '\tuint256 public constant decimals = 18;\n', '    \n', '    uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z\n', '    uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z\n', '\n', '    mapping(address => bool) public rc;\n', '\n', '\n', '    function TokenSale(address _tokenAddress, address _rateAddress, uint256 _startTime, uint256 _endTime) public {\n', '        tokenContract = tokenInterface(_tokenAddress);\n', '        rateContract = rateInterface(_rateAddress);\n', '        setTime(_startTime, _endTime); \n', '        wallet = msg.sender;\n', '        advisor = msg.sender;\n', '        advisorFee = 0 * 10**3;\n', '    }\n', '    \n', '    function tokenValueInEther(uint256 _oneTokenInFiatWei) public view returns(uint256 tknValue) {\n', '        uint256 oneEtherInUsd = rateContract.readRate("usd");\n', '        tknValue = _oneTokenInFiatWei.mul(10 ** uint256(decimals)).div(oneEtherInUsd);\n', '        return tknValue;\n', '    } \n', '    \n', '    modifier isBuyable() {\n', '        require( now > startTime ); // check if started\n', '        require( now < endTime ); // check if ended\n', '        require( msg.value > 0 );\n', '\t\t\n', '\t\tuint256 remainingTokens = tokenContract.balanceOf(this);\n', '        require( remainingTokens > 0 ); // Check if there are any remaining tokens \n', '        _;\n', '    }\n', '    \n', '    event Buy(address buyer, uint256 value, address indexed ambassador);\n', '    \n', '    modifier onlyRC() {\n', '        require( rc[msg.sender] ); //check if is an authorized rcContract\n', '        _;\n', '    }\n', '    \n', '    function buyFromRC(address _buyer, uint256 _rcTokenValue, uint256 _remainingTokens) onlyRC isBuyable public payable returns(uint256) {\n', '        uint256 oneToken = 10 ** uint256(decimals);\n', '        uint256 tokenValue = tokenValueInEther(_rcTokenValue);\n', '        uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);\n', '        address _ambassador = msg.sender;\n', '        \n', '        \n', '        uint256 remainingTokens = tokenContract.balanceOf(this);\n', '        if ( _remainingTokens < remainingTokens ) {\n', '            remainingTokens = _remainingTokens;\n', '        }\n', '        \n', '        if ( remainingTokens < tokenAmount ) {\n', '            uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneToken);\n', '            tokenAmount = remainingTokens;\n', '            forward(msg.value-refund);\n', '\t\t\tremainingTokens = 0; // set remaining token to 0\n', '             _buyer.transfer(refund);\n', '        } else {\n', '\t\t\tremainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus\n', '            forward(msg.value);\n', '        }\n', '        \n', '        tokenContract.transfer(_buyer, tokenAmount);\n', '        emit Buy(_buyer, tokenAmount, _ambassador);\n', '\t\t\n', '        return tokenAmount; \n', '    }\n', '    \n', '    function forward(uint256 _amount) internal {\n', '        uint256 advisorAmount = _amount.mul(advisorFee).div(10**3);\n', '        uint256 walletAmount = _amount - advisorAmount;\n', '        advisor.transfer(advisorAmount);\n', '        wallet.transfer(walletAmount);\n', '    }\n', '\n', '    event NewRC(address contr);\n', '    \n', '    function addMeByRC() public {\n', '        require(tx.origin == owner);\n', '        \n', '        rc[ msg.sender ]  = true;\n', '        \n', '        emit NewRC(msg.sender);\n', '    }\n', '    \n', '    function setTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {\n', '        if ( _newStart != 0 ) startTime = _newStart;\n', '        if ( _newEnd != 0 ) endTime = _newEnd;\n', '    }\n', '\n', '    function withdraw(address to, uint256 value) public onlyOwner {\n', '        to.transfer(value);\n', '    }\n', '    \n', '    function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {\n', '        return tokenContract.transfer(to, value);\n', '    }\n', '    \n', '    function setTokenContract(address _tokenContract) public onlyOwner {\n', '        tokenContract = tokenInterface(_tokenContract);\n', '    }\n', '\n', '    function setWalletAddress(address _wallet) public onlyOwner {\n', '        wallet = _wallet;\n', '    }\n', '    \n', '    function setAdvisorAddress(address _advisor) public onlyOwner {\n', '            advisor = _advisor;\n', '    }\n', '    \n', '    function setAdvisorFee(uint256 _advisorFee) public onlyOwner {\n', '            advisorFee = _advisorFee;\n', '    }\n', '    \n', '    function setRateContract(address _rateAddress) public onlyOwner {\n', '        rateContract = rateInterface(_rateAddress);\n', '    }\n', '\t\n', '\tfunction claim(address _buyer, uint256 _amount) onlyRC public returns(bool) {\n', '        return tokenContract.transfer(_buyer, _amount);\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}']