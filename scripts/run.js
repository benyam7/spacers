
const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    // how is hre imported? everytime npx hardhat, you're getting the hre object built on the fly usin the hardhat.confi.js
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal") // compiles our contract, and generates neccessary files in artifact director
    const waveContract = await waveContractFactory.deploy(); // hard hat will create a new local etheeum network for us, but only for this contract.After, script complete it will be destroyed. so, everytime we run our contract, it's run on fresh blockchain
    await waveContract.deployed(); // wait utill our contract is deployed

    console.log("Contract deployed to: ", waveContract.address)
    console.log("Contract deployed by", owner.address)

    let waveCount;
    waveCount = await waveContract.getTotalWaves(); // we're not waitin for it like one below, cause it's view function i.e doesn't change state of deve

    let waveTxn = await waveContract.wave();
    await waveTxn.wait(); // i think we're waiting for it because, and this function changes state of the blockchain

    waveCount = await waveContract.getTotalWaves();

    // add other persons to wave, (in our case we're gettin a random address, and using that to mimic other people waving)
    waveTxn = await waveContract.connect(randomPerson).wave()
    await waveTxn.wait();
    
    waveCount = await waveContract.getTotalWaves();

    waveTxn = await waveContract.connect(randomPerson).wave()
    await waveTxn.wait()

    waveCount = await waveContract.getTotalWaves();
    
}

const runMain = async () => {
    try{
        await main();
        process.exit(0); // exit node process without error
    } catch(error){
        console.log(error);
        process.exit(1) // exit node process while indicatin 'Uncaught fatal exception' error
    
    }
}

runMain()