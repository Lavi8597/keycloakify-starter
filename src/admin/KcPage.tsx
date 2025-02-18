/**
 * This file has been claimed for ownership from @keycloakify/keycloak-admin-ui version 260007.0.4.
 * To relinquish ownership and restore this file to its original content, run the following command:
 *
 * $ npx keycloakify own --path 'admin/KcPage.tsx' --revert
 */

import { lazy } from "react";
import { KcAdminUiLoader } from "@keycloakify/keycloak-admin-ui";
import { KcContext } from "./KcContext";
import "./main.css";

const KcAdminUi = lazy(() => import("./KcAdminUi"));

export default function KcPage(props: { kcContext: KcContext }) {
    const { kcContext } = props;

    return <KcAdminUiLoader kcContext={kcContext} KcAdminUi={KcAdminUi} />;
}
