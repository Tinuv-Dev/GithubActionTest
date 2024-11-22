import Foundation

// 下载文件的函数
func downloadFile(from url: String, to destinationPath: String) {
    guard let fileURL = URL(string: url) else {
        print("无效的 URL: \(url)")
        return
    }
    
    let destinationURL = URL(fileURLWithPath: destinationPath)
    let session = URLSession(configuration: .default)
    
    // 创建一个运行循环控制的标志
    var isFinished = false
    
    let downloadTask = session.downloadTask(with: fileURL) { (tempURL, response, error) in
        if let error = error {
            print("下载失败: \(error.localizedDescription)")
            isFinished = true // 标记完成
            return
        }
        
        guard let tempURL = tempURL else {
            print("下载失败: 无法找到临时文件")
            isFinished = true // 标记完成
            return
        }
        
        do {
            try FileManager.default.moveItem(at: tempURL, to: destinationURL)
            print("文件已保存至 \(destinationURL.path)")
        } catch {
            print("无法保存文件: \(error.localizedDescription)")
        }
        
        isFinished = true // 标记完成
    }
    
    downloadTask.resume()
    
    // 运行循环保持运行直到任务完成
    let runLoop = RunLoop.current
    while !isFinished && runLoop.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1)) {}
}

// 主函数
func main() {
    let arguments = CommandLine.arguments
    guard arguments.count == 3 else {
        print("使用方式: \(arguments[0]) <URL> <保存路径>")
        return
    }
    
    let url = arguments[1]
    let destinationPath = arguments[2]
    
    downloadFile(from: url, to: destinationPath)
}

// 启动主函数
main()

