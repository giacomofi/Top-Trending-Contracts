['// basic multisig wallet with spending limits, token types and other controls built in\n', '// wondering if I should build in a master lock which enables free spend after a certain time?\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic\n', '{\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract MultiSig\n', '{\n', '  address constant internal CONTRACT_SIGNATURE1 = 0xa5a5f62BfA22b1E42A98Ce00131eA658D5E29B37; // SB\n', '  address constant internal CONTRACT_SIGNATURE2 = 0x9115a6162D6bC3663dC7f4Ea46ad87db6B9CB926; // SM\n', '  \n', '  mapping(address => uint256) internal mSignatures;\n', '  mapping(address => uint256) internal mLastSpend;\n', '  \n', '  // gas limit\n', '  uint256 public GAS_PRICE_LIMIT = 200 * 10**9;                       // Gas limit 200 gwei\n', '  \n', '  // live parameters\n', '  uint256 public constant WHOLE_ETHER = 10**18;\n', '  uint256 public constant FRACTION_ETHER = 10**14;\n', '  uint256 public constant COSIGN_MAX_TIME= 900; // maximum delay between signatures\n', '  uint256 public constant DAY_LENGTH  = 300; // length of day in seconds\n', '  \n', '  // ether spending\n', '  uint256 public constant MAX_DAILY_SOLO_SPEND = (5*WHOLE_ETHER); // amount which can be withdrawn without co-signing\n', '  uint256 public constant MAX_DAILY_COSIGN_SEND = (500*WHOLE_ETHER);\n', '  \n', '  // token spending\n', '  uint256 public constant MAX_DAILY_TOKEN_SOLO_SPEND = 2500000*WHOLE_ETHER; // ~5 eth\n', '  uint256 public constant MAX_DAILY_TOKEN_COSIGN_SPEND = 250000000*WHOLE_ETHER; // ~500 eth\n', '  \n', '  uint256 internal mAmount1=0;\n', '  uint256 internal mAmount2=0;\n', '\n', '  // set the time of a signature\n', '  function sendsignature() internal\n', '  {\n', '       // check if these signatures are authorised\n', '        require((msg.sender == CONTRACT_SIGNATURE1 || msg.sender == CONTRACT_SIGNATURE2));//, "Only signatories can sign");\n', '        \n', '        // assign signature\n', '        uint256 timestamp = block.timestamp;\n', '        mSignatures[msg.sender] = timestamp;\n', '  }\n', '  \n', '  // inserted for paranoia but may need to change gas prices in future\n', '  function SetGasLimit(uint256 newGasLimit) public\n', '  {\n', '      require((msg.sender == CONTRACT_SIGNATURE1 || msg.sender == CONTRACT_SIGNATURE2));//, "Only signatories can call");\n', '      GAS_PRICE_LIMIT = newGasLimit;                       // Gas limit default 200 gwei\n', '  }\n', '    \n', '  // implicitly calls spend - if both signatures have signed we then spend\n', '  function spendlarge(uint256 _to, uint256 _main, uint256 _fraction) public returns (bool valid)\n', '  {\n', '        require( _to != 0x0);//, "Must send to valid address");\n', '        require( _main<= MAX_DAILY_COSIGN_SEND);//, "Cannot spend more than 500 eth");\n', '        require( _fraction< (WHOLE_ETHER/FRACTION_ETHER));//, "Fraction must be less than 10000");\n', '        require (tx.gasprice <= GAS_PRICE_LIMIT);//, "tx.gasprice exceeds limit");\n', '        // usually called after sign but will work if top level function is called by both parties\n', '        sendsignature();\n', '        \n', '        uint256 currentTime = block.timestamp;\n', '        uint256 valid1=0;\n', '        uint256 valid2=0;\n', '        \n', '        // check both signatures have been logged within the time frame\n', '        // one of these times will obviously be zero\n', '        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE1] < COSIGN_MAX_TIME)\n', '        {\n', '            mAmount1 = _main*WHOLE_ETHER + _fraction*FRACTION_ETHER;\n', '            valid1=1;\n', '        }\n', '        \n', '        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE2] < COSIGN_MAX_TIME)\n', '        {\n', '            mAmount2 = _main*WHOLE_ETHER + _fraction*FRACTION_ETHER;\n', '            valid2=1;\n', '        }\n', '        \n', '        if (valid1==1 && valid2==1) //"Both signatures must sign");\n', '        {\n', '            // if this was called in less than 24 hours then don&#39;t allow spend\n', '            require( (currentTime - mLastSpend[msg.sender]) > DAY_LENGTH);//, "You can&#39;t call this more than once per day per signature");\n', '        \n', '            if (mAmount1 == mAmount2)\n', '            {\n', '                // transfer eth to the destination\n', '                address(_to).transfer(mAmount1);\n', '                \n', '                // clear the state\n', '                valid1=0;\n', '                valid2=0;\n', '                mAmount1=0;\n', '                mAmount2=0;\n', '                \n', '                // clear the signature timestamps\n', '                endsigning();\n', '                \n', '                return true;\n', '            }\n', '        }\n', '        \n', '        // out of time or need another signature\n', '        return false;\n', '  }\n', '  \n', '  // used for individual wallet holders to take a small amount of ether\n', '  function takedaily(address _to) public returns (bool valid)\n', '  {\n', '    require( _to != 0x0);//, "Must send to valid address");\n', '    require (tx.gasprice <= GAS_PRICE_LIMIT);//, "tx.gasprice exceeds limit");\n', '    \n', '    // check if these signatures are authorised\n', '    require((msg.sender == CONTRACT_SIGNATURE1 || msg.sender == CONTRACT_SIGNATURE2));//, "Only signatories can sign");\n', '        \n', '    uint256 currentTime = block.timestamp;\n', '        \n', '    // if this was called in less than 24 hours then don&#39;t allow spend\n', '    require(currentTime - mLastSpend[msg.sender] > DAY_LENGTH);//, "You can&#39;t call this more than once per day per signature");\n', '    \n', '    // transfer eth to the destination\n', '    _to.transfer(MAX_DAILY_SOLO_SPEND);\n', '                \n', '    mLastSpend[msg.sender] = currentTime;\n', '                \n', '    return true;\n', '  }\n', '  \n', '  // implicitly calls spend - if both signatures have signed we then spend\n', '  function spendtokens(ERC20Basic contractaddress, uint256 _to, uint256 _main, uint256 _fraction) public returns (bool valid)\n', '  {\n', '        require( _to != 0x0);//, "Must send to valid address");\n', '        require(_main <= MAX_DAILY_TOKEN_COSIGN_SPEND);// , "Cannot spend more than 150000000 per day");\n', '        require(_fraction< (WHOLE_ETHER/FRACTION_ETHER));//, "Fraction must be less than 10000");\n', '        \n', '        // usually called after sign but will work if top level function is called by both parties\n', '        sendsignature();\n', '        \n', '        uint256 currentTime = block.timestamp;\n', '        uint256 valid1=0;\n', '        uint256 valid2=0;\n', '        \n', '        // check both signatures have been logged within the time frame\n', '        // one of these times will obviously be zero\n', '        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE1] < COSIGN_MAX_TIME)\n', '        {\n', '            mAmount1 = _main*WHOLE_ETHER + _fraction*FRACTION_ETHER;\n', '            valid1=1;\n', '        }\n', '        \n', '        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE2] < COSIGN_MAX_TIME)\n', '        {\n', '            mAmount2 = _main*WHOLE_ETHER + _fraction*FRACTION_ETHER;\n', '            valid2=1;\n', '        }\n', '        \n', '        if (valid1==1 && valid2==1) //"Both signatures must sign");\n', '        {\n', '            // if this was called in less than 24 hours then don&#39;t allow spend\n', '            require(currentTime - mLastSpend[msg.sender] > DAY_LENGTH);//, "You can&#39;t call this more than once per day per signature");\n', '        \n', '            if (mAmount1 == mAmount2)\n', '            {\n', '                uint256 valuetosend = _main*WHOLE_ETHER + _fraction*FRACTION_ETHER;\n', '                // transfer eth to the destination\n', '                contractaddress.transfer(address(_to), valuetosend);\n', '                \n', '                // clear the state\n', '                valid1=0;\n', '                valid2=0;\n', '                mAmount1=0;\n', '                mAmount2=0;\n', '                \n', '                // clear the signature timestamps\n', '                endsigning();\n', '                \n', '                return true;\n', '            }\n', '        }\n', '        \n', '        // out of time or need another signature\n', '        return false;\n', '  }\n', '        \n', '\n', '  // used to take a small amount of daily tokens\n', '  function taketokendaily(ERC20Basic contractaddress, uint256 _to) public returns (bool valid)\n', '  {\n', '    require( _to != 0x0);//, "Must send to valid address");\n', '    \n', '    // check if these signatures are authorised\n', '    require((msg.sender == CONTRACT_SIGNATURE1 || msg.sender == CONTRACT_SIGNATURE2));//, "Only signatories can sign");\n', '        \n', '    uint256 currentTime = block.timestamp;\n', '        \n', '    // if this was called in less than 24 hours then don&#39;t allow spend\n', '    require(currentTime - mLastSpend[msg.sender] > DAY_LENGTH);//, "You can&#39;t call this more than once per day per signature");\n', '    \n', '    // transfer eth to the destination\n', '    contractaddress.transfer(address(_to), MAX_DAILY_TOKEN_SOLO_SPEND);\n', '                \n', '    mLastSpend[msg.sender] = currentTime;\n', '                \n', '    return true;\n', '  }\n', '    \n', '  function endsigning() internal\n', '  {\n', '      // only called when spending was successful - sets the timestamp of last call\n', '      mLastSpend[CONTRACT_SIGNATURE1]=block.timestamp;\n', '      mLastSpend[CONTRACT_SIGNATURE2]=block.timestamp;\n', '      mSignatures[CONTRACT_SIGNATURE1]=0;\n', '      mSignatures[CONTRACT_SIGNATURE2]=0;\n', '  }\n', '  \n', '  function () public payable \n', '    {\n', '       \n', '    }\n', '    \n', '}']