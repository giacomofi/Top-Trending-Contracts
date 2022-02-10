['pragma solidity 0.4.25;\n', '\n', '/**\n', ' * @notice Declares a contract that can have an owner.\n', ' */\n', 'contract OwnedI {\n', '    event LogOwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function getOwner()\n', '        view public\n', '        returns (address);\n', '\n', '    function setOwner(address newOwner)\n', '        public\n', '        returns (bool success); \n', '}\n', '\n', '/**\n', ' * @notice Defines a contract that can have an owner.\n', ' */\n', 'contract Owned is OwnedI {\n', '    /**\n', '     * @dev Made private to protect against child contract setting it to 0 by mistake.\n', '     */\n', '    address private owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier fromOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function getOwner()\n', '        view public\n', '        returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    function setOwner(address newOwner)\n', '        fromOwner public\n', '        returns (bool success) {\n', '        require(newOwner != 0);\n', '        if (owner != newOwner) {\n', '            emit LogOwnerChanged(owner, newOwner);\n', '            owner = newOwner;\n', '        }\n', '        success = true;\n', '    }\n', '}\n', '\n', 'contract WithBeneficiary is Owned {\n', '    /**\n', '     * @notice Address that is forwarded all value.\n', '     * @dev Made private to protect against child contract setting it to 0 by mistake.\n', '     */\n', '    address private beneficiary;\n', '    \n', '    event LogBeneficiarySet(address indexed previousBeneficiary, address indexed newBeneficiary);\n', '\n', '    constructor(address _beneficiary) payable public {\n', '        require(_beneficiary != 0);\n', '        beneficiary = _beneficiary;\n', '        if (msg.value > 0) {\n', '            asyncSend(beneficiary, msg.value);\n', '        }\n', '    }\n', '\n', '    function asyncSend(address dest, uint amount) internal;\n', '\n', '    function getBeneficiary()\n', '        view public\n', '        returns (address) {\n', '        return beneficiary;\n', '    }\n', '\n', '    function setBeneficiary(address newBeneficiary)\n', '        fromOwner public\n', '        returns (bool success) {\n', '        require(newBeneficiary != 0);\n', '        if (beneficiary != newBeneficiary) {\n', '            emit LogBeneficiarySet(beneficiary, newBeneficiary);\n', '            beneficiary = newBeneficiary;\n', '        }\n', '        success = true;\n', '    }\n', '\n', '    function () payable public {\n', '        asyncSend(beneficiary, msg.value);\n', '    }\n', '}\n', '\n', 'contract WithFee is WithBeneficiary {\n', '    // @notice Contracts asking for a confirmation of a certification need to pass this fee.\n', '    uint256 private queryFee;\n', '\n', '    event LogQueryFeeSet(uint256 previousQueryFee, uint256 newQueryFee);\n', '\n', '    constructor(\n', '            address beneficiary,\n', '            uint256 _queryFee) public\n', '        WithBeneficiary(beneficiary) {\n', '        queryFee = _queryFee;\n', '    }\n', '\n', '    modifier requestFeePaid {\n', '        require(queryFee <= msg.value);\n', '        asyncSend(getBeneficiary(), msg.value);\n', '        _;\n', '    }\n', '\n', '    function getQueryFee()\n', '        view public\n', '        returns (uint256) {\n', '        return queryFee;\n', '    }\n', '\n', '    function setQueryFee(uint256 newQueryFee)\n', '        fromOwner public\n', '        returns (bool success) {\n', '        if (queryFee != newQueryFee) {\n', '            emit LogQueryFeeSet(queryFee, newQueryFee);\n', '            queryFee = newQueryFee;\n', '        }\n', '        success = true;\n', '    }\n', '}\n', '\n', '/*\n', ' * @notice Base contract supporting async send for pull payments.\n', ' * Inherit from this contract and use asyncSend instead of send.\n', ' * https://github.com/OpenZeppelin/zep-solidity/blob/master/contracts/PullPaymentCapable.sol\n', ' */\n', 'contract PullPaymentCapable {\n', '    uint256 private totalBalance;\n', '    mapping(address => uint256) private payments;\n', '\n', '    event LogPaymentReceived(address indexed dest, uint256 amount);\n', '\n', '    constructor() public {\n', '        if (0 < address(this).balance) {\n', '            asyncSend(msg.sender, address(this).balance);\n', '        }\n', '    }\n', '\n', '    // store sent amount as credit to be pulled, called by payer\n', '    function asyncSend(address dest, uint256 amount) internal {\n', '        if (amount > 0) {\n', '            totalBalance += amount;\n', '            payments[dest] += amount;\n', '            emit LogPaymentReceived(dest, amount);\n', '        }\n', '    }\n', '\n', '    function getTotalBalance()\n', '        view public\n', '        returns (uint256) {\n', '        return totalBalance;\n', '    }\n', '\n', '    function getPaymentOf(address beneficiary) \n', '        view public\n', '        returns (uint256) {\n', '        return payments[beneficiary];\n', '    }\n', '\n', '    // withdraw accumulated balance, called by payee\n', '    function withdrawPayments()\n', '        external \n', '        returns (bool success) {\n', '        uint256 payment = payments[msg.sender];\n', '        payments[msg.sender] = 0;\n', '        totalBalance -= payment;\n', '        require(msg.sender.call.value(payment)());\n', '        success = true;\n', '    }\n', '\n', '    function fixBalance()\n', '        public\n', '        returns (bool success);\n', '\n', '    function fixBalanceInternal(address dest)\n', '        internal\n', '        returns (bool success) {\n', '        if (totalBalance < address(this).balance) {\n', '            uint256 amount = address(this).balance - totalBalance;\n', '            payments[dest] += amount;\n', '            emit LogPaymentReceived(dest, amount);\n', '        }\n', '        return true;\n', '    }\n', '}\n', '\n', '// @notice Interface for a certifier database\n', 'contract CertifierDbI {\n', '    event LogCertifierAdded(address indexed certifier);\n', '\n', '    event LogCertifierRemoved(address indexed certifier);\n', '\n', '    function addCertifier(address certifier)\n', '        public\n', '        returns (bool success);\n', '\n', '    function removeCertifier(address certifier)\n', '        public\n', '        returns (bool success);\n', '\n', '    function getCertifiersCount()\n', '        view public\n', '        returns (uint count);\n', '\n', '    function getCertifierStatus(address certifierAddr)\n', '        view public \n', '        returns (bool authorised, uint256 index);\n', '\n', '    function getCertifierAtIndex(uint256 index)\n', '        view public\n', '        returns (address);\n', '\n', '    function isCertifier(address certifier)\n', '        view public\n', '        returns (bool isIndeed);\n', '}\n', '\n', 'contract CertificationDbI {\n', '    event LogCertifierDbChanged(\n', '        address indexed previousCertifierDb,\n', '        address indexed newCertifierDb);\n', '\n', '    event LogStudentCertified(\n', '        address indexed student, uint timestamp,\n', '        address indexed certifier, bytes32 indexed document);\n', '\n', '    event LogStudentUncertified(\n', '        address indexed student, uint timestamp,\n', '        address indexed certifier);\n', '\n', '    event LogCertificationDocumentAdded(\n', '        address indexed student, bytes32 indexed document);\n', '\n', '    event LogCertificationDocumentRemoved(\n', '        address indexed student, bytes32 indexed document);\n', '\n', '    function getCertifierDb()\n', '        view public\n', '        returns (address);\n', '\n', '    function setCertifierDb(address newCertifierDb)\n', '        public\n', '        returns (bool success);\n', '\n', '    function certify(address student, bytes32 document)\n', '        public\n', '        returns (bool success);\n', '\n', '    function uncertify(address student)\n', '        public\n', '        returns (bool success);\n', '\n', '    function addCertificationDocument(address student, bytes32 document)\n', '        public\n', '        returns (bool success);\n', '\n', '    function addCertificationDocumentToSelf(bytes32 document)\n', '        public\n', '        returns (bool success);\n', '\n', '    function removeCertificationDocument(address student, bytes32 document)\n', '        public\n', '        returns (bool success);\n', '\n', '    function removeCertificationDocumentFromSelf(bytes32 document)\n', '        public\n', '        returns (bool success);\n', '\n', '    function getCertifiedStudentsCount()\n', '        view public\n', '        returns (uint count);\n', '\n', '    function getCertifiedStudentAtIndex(uint index)\n', '        payable public\n', '        returns (address student);\n', '\n', '    function getCertification(address student)\n', '        payable public\n', '        returns (bool certified, uint timestamp, address certifier, uint documentCount);\n', '\n', '    function isCertified(address student)\n', '        payable public\n', '        returns (bool isIndeed);\n', '\n', '    function getCertificationDocumentAtIndex(address student, uint256 index)\n', '        payable public\n', '        returns (bytes32 document);\n', '\n', '    function isCertification(address student, bytes32 document)\n', '        payable public\n', '        returns (bool isIndeed);\n', '}\n', '\n', 'contract CertificationDb is CertificationDbI, WithFee, PullPaymentCapable {\n', '    // @notice Where we check for certifiers.\n', '    CertifierDbI private certifierDb;\n', '\n', '    struct DocumentStatus {\n', '        bool isValid;\n', '        uint256 index;\n', '    }\n', '\n', '    struct Certification {\n', '        bool certified;\n', '        uint256 timestamp;\n', '        address certifier;\n', '        mapping(bytes32 => DocumentStatus) documentStatuses;\n', '        bytes32[] documents;\n', '        uint256 index;\n', '    }\n', '\n', '    // @notice Address of certified students.\n', '    mapping(address => Certification) studentCertifications;\n', '    // @notice The potentially long list of all certified students.\n', '    address[] certifiedStudents;\n', '\n', '    constructor(\n', '            address beneficiary,\n', '            uint256 certificationQueryFee,\n', '            address _certifierDb)\n', '            public\n', '            WithFee(beneficiary, certificationQueryFee) {\n', '        require(_certifierDb != 0);\n', '        certifierDb = CertifierDbI(_certifierDb);\n', '    }\n', '\n', '    modifier fromCertifier {\n', '        require(certifierDb.isCertifier(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function getCertifierDb()\n', '        view public\n', '        returns (address) {\n', '        return certifierDb;\n', '    }\n', '\n', '    function setCertifierDb(address newCertifierDb)\n', '        fromOwner public\n', '        returns (bool success) {\n', '        require(newCertifierDb != 0);\n', '        if (certifierDb != newCertifierDb) {\n', '            emit LogCertifierDbChanged(certifierDb, newCertifierDb);\n', '            certifierDb = CertifierDbI(newCertifierDb);\n', '        }\n', '        success = true;\n', '    }\n', '\n', '    function certify(address student, bytes32 document) \n', '        fromCertifier public\n', '        returns (bool success) {\n', '        require(student != 0);\n', '        require(!studentCertifications[student].certified);\n', '        bool documentExists = document != 0;\n', '        studentCertifications[student] = Certification({\n', '            certified: true,\n', '            timestamp: now,\n', '            certifier: msg.sender,\n', '            documents: new bytes32[](0),\n', '            index: certifiedStudents.length\n', '        });\n', '        if (documentExists) {\n', '            studentCertifications[student].documentStatuses[document] = DocumentStatus({\n', '                isValid: true,\n', '                index: studentCertifications[student].documents.length\n', '            });\n', '            studentCertifications[student].documents.push(document);\n', '        }\n', '        certifiedStudents.push(student);\n', '        emit LogStudentCertified(student, now, msg.sender, document);\n', '        success = true;\n', '    }\n', '\n', '    function uncertify(address student) \n', '        fromCertifier public\n', '        returns (bool success) {\n', '        require(studentCertifications[student].certified);\n', '        // You need to uncertify all documents first\n', '        require(studentCertifications[student].documents.length == 0);\n', '        uint256 index = studentCertifications[student].index;\n', '        delete studentCertifications[student];\n', '        if (certifiedStudents.length > 1) {\n', '            certifiedStudents[index] = certifiedStudents[certifiedStudents.length - 1];\n', '            studentCertifications[certifiedStudents[index]].index = index;\n', '        }\n', '        certifiedStudents.length--;\n', '        emit LogStudentUncertified(student, now, msg.sender);\n', '        success = true;\n', '    }\n', '\n', '    function addCertificationDocument(address student, bytes32 document)\n', '        fromCertifier public\n', '        returns (bool success) {\n', '        success = addCertificationDocumentInternal(student, document);\n', '    }\n', '\n', '    function addCertificationDocumentToSelf(bytes32 document)\n', '        public\n', '        returns (bool success) {\n', '        success = addCertificationDocumentInternal(msg.sender, document);\n', '    }\n', '\n', '    function addCertificationDocumentInternal(address student, bytes32 document)\n', '        internal\n', '        returns (bool success) {\n', '        require(studentCertifications[student].certified);\n', '        require(document != 0);\n', '        Certification storage certification = studentCertifications[student];\n', '        if (!certification.documentStatuses[document].isValid) {\n', '            certification.documentStatuses[document] = DocumentStatus({\n', '                isValid:  true,\n', '                index: certification.documents.length\n', '            });\n', '            certification.documents.push(document);\n', '            emit LogCertificationDocumentAdded(student, document);\n', '        }\n', '        success = true;\n', '    }\n', '\n', '    function removeCertificationDocument(address student, bytes32 document)\n', '        fromCertifier public\n', '        returns (bool success) {\n', '        success = removeCertificationDocumentInternal(student, document);\n', '    }\n', '\n', '    function removeCertificationDocumentFromSelf(bytes32 document)\n', '        public\n', '        returns (bool success) {\n', '        success = removeCertificationDocumentInternal(msg.sender, document);\n', '    }\n', '\n', '    function removeCertificationDocumentInternal(address student, bytes32 document)\n', '        internal\n', '        returns (bool success) {\n', '        require(studentCertifications[student].certified);\n', '        Certification storage certification = studentCertifications[student];\n', '        if (certification.documentStatuses[document].isValid) {\n', '            uint256 index = certification.documentStatuses[document].index;\n', '            delete certification.documentStatuses[document];\n', '            if (certification.documents.length > 1) {\n', '                certification.documents[index] =\n', '                    certification.documents[certification.documents.length - 1];\n', '                certification.documentStatuses[certification.documents[index]].index = index;\n', '            }\n', '            certification.documents.length--;\n', '            emit LogCertificationDocumentRemoved(student, document);\n', '        }\n', '        success = true;\n', '    }\n', '\n', '    function getCertifiedStudentsCount()\n', '        view public\n', '        returns (uint256 count) {\n', '        count = certifiedStudents.length;\n', '    }\n', '\n', '    function getCertifiedStudentAtIndex(uint256 index)\n', '        payable public\n', '        requestFeePaid\n', '        returns (address student) {\n', '        student = certifiedStudents[index];\n', '    }\n', '\n', '    /**\n', '     * @notice Requesting a certification is a paying feature.\n', '     */\n', '    function getCertification(address student)\n', '        payable public\n', '        requestFeePaid\n', '        returns (bool certified, uint256 timestamp, address certifier, uint256 documentCount) {\n', '        Certification storage certification = studentCertifications[student];\n', '        return (certification.certified,\n', '            certification.timestamp,\n', '            certification.certifier,\n', '            certification.documents.length);\n', '    }\n', '\n', '    /**\n', '     * @notice Requesting a certification confirmation is a paying feature.\n', '     */\n', '    function isCertified(address student)\n', '        payable public\n', '        requestFeePaid\n', '        returns (bool isIndeed) {\n', '        isIndeed = studentCertifications[student].certified;\n', '    }\n', '\n', '    /**\n', '     * @notice Requesting a certification document by index is a paying feature.\n', '     */\n', '    function getCertificationDocumentAtIndex(address student, uint256 index)\n', '        payable public\n', '        requestFeePaid\n', '        returns (bytes32 document) {\n', '        document = studentCertifications[student].documents[index];\n', '    }\n', '\n', '    /**\n', '     * @notice Requesting a confirmation that a document is a certification is a paying feature.\n', '     */\n', '    function isCertification(address student, bytes32 document)\n', '        payable public\n', '        requestFeePaid\n', '        returns (bool isIndeed) {\n', '        isIndeed = studentCertifications[student].documentStatuses[document].isValid;\n', '    }\n', '\n', '    function fixBalance()\n', '        public\n', '        returns (bool success) {\n', '        return fixBalanceInternal(getBeneficiary());\n', '    }\n', '}']