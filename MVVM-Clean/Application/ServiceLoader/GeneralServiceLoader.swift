/*
 * Copyright (c) Rakuten Payment, Inc. All Rights Reserved.
 *
 * This program is the information asset which are handled
 * as "Strictly Confidential".
 * Permission of use is only admitted in Rakuten Payment, Inc.
 * If you don't have permission, MUST not be published,
 * broadcast, rewritten for broadcast or publication
 * or redistributed directly or indirectly in any medium.
 */

import Foundation
import NetworkInfra
public struct GeneralServiceLoader{

    public func  bookListAPILoader() -> DataServiceLoader {
        let config = RemoteConfing(fetchUrl: EnvironmentSetting.BOOKLIST_REST_API_URL)
        let service = RemoteNetworkService(config: config)
        return RemoteDataLoader(inService: service)
    }
    
}
