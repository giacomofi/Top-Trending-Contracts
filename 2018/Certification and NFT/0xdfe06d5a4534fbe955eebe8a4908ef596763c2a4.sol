['pragma solidity ^0.4.17;\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Application Asset Contract ABI\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', ' Any contract inheriting this will be usable as an Asset in the Application Entity\n', '\n', '*/\n', '\n', '\n', '\n', 'contract ABIApplicationAsset {\n', '\n', '    bytes32 public assetName;\n', '    uint8 public CurrentEntityState;\n', '    uint8 public RecordNum;\n', '    bool public _initialized;\n', '    bool public _settingsApplied;\n', '    address public owner;\n', '    address public deployerAddress;\n', '    mapping (bytes32 => uint8) public EntityStates;\n', '    mapping (bytes32 => uint8) public RecordStates;\n', '\n', '    function setInitialApplicationAddress(address _ownerAddress) public;\n', '    function setInitialOwnerAndName(bytes32 _name) external returns (bool);\n', '    function getRecordState(bytes32 name) public view returns (uint8);\n', '    function getEntityState(bytes32 name) public view returns (uint8);\n', '    function applyAndLockSettings() public returns(bool);\n', '    function transferToNewOwner(address _newOwner) public returns (bool);\n', '    function getApplicationAssetAddressByName(bytes32 _name) public returns(address);\n', '    function getApplicationState() public view returns (uint8);\n', '    function getApplicationEntityState(bytes32 name) public view returns (uint8);\n', '    function getAppBylawUint256(bytes32 name) public view returns (uint256);\n', '    function getAppBylawBytes32(bytes32 name) public view returns (bytes32);\n', '    function getTimestamp() view public returns (uint256);\n', '\n', '\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Token Manager Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', '*/\n', '\n', '\n', '\n', '\n', '\n', 'contract ABITokenManager is ABIApplicationAsset {\n', '\n', '    address public TokenSCADAEntity;\n', '    address public TokenEntity;\n', '    address public MarketingMethodAddress;\n', '    bool OwnerTokenBalancesReleased = false;\n', '\n', '    function addSettings(address _scadaAddress, address _tokenAddress, address _marketing ) public;\n', '    function getTokenSCADARequiresHardCap() public view returns (bool);\n', '    function mint(address _to, uint256 _amount) public returns (bool);\n', '    function finishMinting() public returns (bool);\n', '    function mintForMarketingPool(address _to, uint256 _amount) external returns (bool);\n', '    function ReleaseOwnersLockedTokens(address _multiSigOutputAddress) public returns (bool);\n', '\n', '}\n', '\n', '/*\n', '\n', ' * source       https://github.com/blockbitsio/\n', '\n', ' * @name        Marketing Funding Input Contract\n', ' * @package     BlockBitsIO\n', ' * @author      Micky Socaci <micky@nowlive.ro>\n', '\n', '\n', ' Classic funding method that receives ETH and mints tokens directly\n', '    - has hard cap.\n', '    - minted supply affects final token supply.\n', '    - does not use vaults, mints directly to sender address.\n', "    - accepts over cap payment and returns what's left back to sender.\n", '  Funds used exclusively for Marketing\n', '\n', '*/\n', '\n', '\n', '\n', '\n', 'contract ExtraFundingInputMarketing {\n', '\n', '    ABITokenManager public TokenManagerEntity;\n', '    address public outputWalletAddress;\n', '    uint256 public hardCap;\n', '    uint256 public tokensPerEth;\n', '\n', '    uint256 public start_time;\n', '    uint256 public end_time;\n', '\n', '    uint256 public AmountRaised = 0;\n', '\n', '    address public deployer;\n', '    bool public settings_added = false;\n', '\n', '    function ExtraFundingInputMarketing() public {\n', '        deployer = msg.sender;\n', '    }\n', '\n', '    function addSettings(\n', '        address _tokenManager,\n', '        address _outputWalletAddress,\n', '        uint256 _cap,\n', '        uint256 _price,\n', '        uint256 _start_time,\n', '        uint256 _endtime\n', '    )\n', '        public\n', '    {\n', '        require(msg.sender == deployer);\n', '        require(settings_added == false);\n', '\n', '        TokenManagerEntity = ABITokenManager(_tokenManager);\n', '        outputWalletAddress = _outputWalletAddress;\n', '        hardCap = _cap;\n', '        tokensPerEth = _price;\n', '        start_time = _start_time;\n', '        end_time = _endtime;\n', '        settings_added = true;\n', '    }\n', '\n', '    event EventInputPaymentReceived(address sender, uint amount);\n', '\n', '    function () public payable {\n', '        buy();\n', '    }\n', '\n', '    function buy() public payable returns(bool) {\n', '        if(msg.value > 0) {\n', '            if( canAcceptPayment() ) {\n', '\n', '                uint256 contributed_value = msg.value;\n', '                uint256 amountOverCap = getValueOverCurrentCap(contributed_value);\n', '                if ( amountOverCap > 0 ) {\n', '                    // calculate how much we can accept\n', '\n', '                    // update contributed value\n', '                    contributed_value -= amountOverCap;\n', '                }\n', '\n', '                // update raised value\n', '                AmountRaised+= contributed_value;\n', '\n', '                // allocate tokens to contributor based on value\n', '                uint256 tokenAmount = getTokensForValue( contributed_value );\n', '                TokenManagerEntity.mintForMarketingPool( msg.sender, tokenAmount);\n', '\n', '                // transfer contributed value to platform wallet\n', '                if( !outputWalletAddress.send(contributed_value) ) {\n', '                    revert();\n', '                }\n', '\n', '                if(amountOverCap > 0) {\n', '                    // last step, if we received more than we can accept, send remaining back\n', '                    // amountOverCap sent back\n', '                    if( msg.sender.send(this.balance) ) {\n', '                        return true;\n', '                    }\n', '                    else {\n', '                        revert();\n', '                    }\n', '                } else {\n', '                    return true;\n', '                }\n', '            } else {\n', '                revert();\n', '            }\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function canAcceptPayment() public view returns (bool) {\n', '        if( (getTimestamp() >= start_time && getTimestamp() <= end_time) && (AmountRaised < hardCap) ) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function getTokensForValue( uint256 _value) public view returns (uint256) {\n', '        return _value * tokensPerEth;\n', '    }\n', '\n', '    function getValueOverCurrentCap(uint256 _amount) public view returns (uint256) {\n', '        uint256 remaining = hardCap - AmountRaised;\n', '        if( _amount > remaining ) {\n', '            return _amount - remaining;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function getTimestamp() view public returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '}']